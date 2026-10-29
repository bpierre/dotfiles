use std::time::Duration;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Outcome {
    /// A previously deferred release expired before the current press.
    pub emit_deferred_release: bool,
    /// Forward the current physical event.
    pub emit_current: bool,
    /// The release-to-press interval when a chatter pair was suppressed.
    pub chatter_gap: Option<Duration>,
}

impl Outcome {
    const fn none() -> Self {
        Self {
            emit_deferred_release: false,
            emit_current: false,
            chatter_gap: None,
        }
    }
}

#[derive(Debug, Clone, Copy)]
struct PendingRelease {
    event_at: Duration,
    deadline: Duration,
}

/// Debounces one momentary button using eager presses and deferred releases.
///
/// `event_at` is the timestamp supplied by the input device. `received_at` is
/// a monotonic process-local timestamp used only to schedule the release
/// timer. Keeping these clocks separate means batched kernel events retain
/// their real spacing without making timers vulnerable to wall-clock changes.
#[derive(Debug)]
pub struct Debouncer {
    window: Duration,
    logical_down: bool,
    pending_release: Option<PendingRelease>,
}

impl Debouncer {
    pub fn new(window: Duration) -> Self {
        assert!(!window.is_zero(), "debounce window must be non-zero");
        Self {
            window,
            logical_down: false,
            pending_release: None,
        }
    }

    /// Handles a physical button value (`1` for press, `0` for release).
    pub fn handle(&mut self, event_at: Duration, received_at: Duration, value: i32) -> Outcome {
        match value {
            1 => self.press(event_at),
            0 => self.release(event_at, received_at),
            // Mouse buttons do not repeat. Ignore malformed/repeat values
            // rather than letting them corrupt the state machine.
            _ => Outcome::none(),
        }
    }

    /// Emits a pending release once its monotonic deadline has elapsed.
    pub fn flush(&mut self, received_at: Duration) -> bool {
        let Some(pending) = self.pending_release else {
            return false;
        };
        if received_at < pending.deadline {
            return false;
        }

        self.pending_release = None;
        self.logical_down = false;
        true
    }

    pub fn remaining(&self, received_at: Duration) -> Option<Duration> {
        self.pending_release
            .map(|pending| pending.deadline.saturating_sub(received_at))
    }

    fn press(&mut self, event_at: Duration) -> Outcome {
        if let Some(pending) = self.pending_release.take() {
            let gap = event_at.checked_sub(pending.event_at);
            if gap.is_some_and(|gap| gap <= self.window) {
                // The logical button never went up, so both physical
                // transitions disappear.
                return Outcome {
                    chatter_gap: gap,
                    ..Outcome::none()
                };
            }

            // The release genuinely expired before this press. Preserve the
            // ordering by emitting it in its own frame before this press.
            self.logical_down = true;
            return Outcome {
                emit_deferred_release: true,
                emit_current: true,
                chatter_gap: None,
            };
        }

        if self.logical_down {
            // Duplicate press with no intervening release.
            return Outcome::none();
        }

        self.logical_down = true;
        Outcome {
            emit_current: true,
            ..Outcome::none()
        }
    }

    fn release(&mut self, event_at: Duration, received_at: Duration) -> Outcome {
        if !self.logical_down || self.pending_release.is_some() {
            // Ignore an initial/duplicate release. Keep the first pending
            // release's deadline so noise cannot extend it forever.
            return Outcome::none();
        }

        self.pending_release = Some(PendingRelease {
            event_at,
            deadline: received_at + self.window,
        });
        Outcome::none()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn ms(value: u64) -> Duration {
        Duration::from_millis(value)
    }

    #[test]
    fn normal_click_defers_only_the_release() {
        let mut d = Debouncer::new(ms(50));

        assert!(d.handle(ms(0), ms(0), 1).emit_current);
        assert_eq!(d.handle(ms(125), ms(125), 0), Outcome::none());
        assert!(!d.flush(ms(174)));
        assert!(d.flush(ms(175)));
        assert!(!d.flush(ms(176)));
    }

    #[test]
    fn suppresses_captured_nine_millisecond_chatter() {
        let mut d = Debouncer::new(ms(50));

        assert!(d.handle(ms(0), ms(0), 1).emit_current);
        d.handle(ms(25), ms(25), 0);
        let bounce = d.handle(ms(34), ms(34), 1);
        assert_eq!(bounce.chatter_gap, Some(ms(9)));
        assert!(!bounce.emit_current);

        d.handle(ms(191), ms(191), 0);
        assert!(d.flush(ms(241)));
    }

    #[test]
    fn suppresses_captured_thirty_two_millisecond_chatter() {
        let mut d = Debouncer::new(ms(50));

        assert!(d.handle(ms(0), ms(0), 1).emit_current);
        d.handle(ms(91), ms(91), 0);
        assert_eq!(d.handle(ms(123), ms(123), 1).chatter_gap, Some(ms(32)));
        d.handle(ms(158), ms(158), 0);
        assert!(d.flush(ms(208)));
    }

    #[test]
    fn boundary_is_inclusive() {
        let mut d = Debouncer::new(ms(50));

        d.handle(ms(0), ms(0), 1);
        d.handle(ms(100), ms(100), 0);
        assert_eq!(d.handle(ms(150), ms(120), 1).chatter_gap, Some(ms(50)));
    }

    #[test]
    fn press_after_window_preserves_release_then_press() {
        let mut d = Debouncer::new(ms(50));

        d.handle(ms(0), ms(0), 1);
        d.handle(ms(100), ms(100), 0);
        let next = d.handle(ms(151), ms(120), 1);
        assert!(next.emit_deferred_release);
        assert!(next.emit_current);
        assert_eq!(next.chatter_gap, None);
    }

    #[test]
    fn batching_does_not_destroy_kernel_timing() {
        let mut d = Debouncer::new(ms(50));
        let same_receipt_time = ms(500);

        assert!(d.handle(ms(0), same_receipt_time, 1).emit_current);
        d.handle(ms(100), same_receipt_time, 0);
        let next = d.handle(ms(132), same_receipt_time, 1);

        assert_eq!(next.chatter_gap, Some(ms(32)));
        assert!(!next.emit_current);
    }

    #[test]
    fn duplicate_release_does_not_extend_deadline() {
        let mut d = Debouncer::new(ms(50));

        d.handle(ms(0), ms(0), 1);
        d.handle(ms(100), ms(100), 0);
        d.handle(ms(110), ms(110), 0);

        assert!(d.flush(ms(150)));
    }

    #[test]
    fn duplicate_press_is_ignored() {
        let mut d = Debouncer::new(ms(50));

        assert!(d.handle(ms(0), ms(0), 1).emit_current);
        assert_eq!(d.handle(ms(10), ms(10), 1), Outcome::none());
    }

    #[test]
    fn initial_release_is_ignored() {
        let mut d = Debouncer::new(ms(50));

        assert_eq!(d.handle(ms(0), ms(0), 0), Outcome::none());
        assert_eq!(d.remaining(ms(0)), None);
    }
}
