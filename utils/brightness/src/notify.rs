use std::{collections::HashMap, error::Error};
use zbus::zvariant::Value;
use zbus::{dbus_proxy, Connection};

// Creates `NotificationProxy` based on the `Notifications` trait.
#[dbus_proxy(
    interface = "org.freedesktop.Notifications",
    default_service = "org.freedesktop.Notifications",
    default_path = "/org/freedesktop/Notifications"
)]
trait BrightnessNotifications {
    fn notify(
        &self,
        app_name: &str,
        replaces_id: u32,
        app_icon: &str,
        summary: &str,
        body: &str,
        actions: &[&str],
        hints: &HashMap<&str, &Value<'_>>,
        expire_timeout: i32,
    ) -> zbus::Result<u32>;
}

pub async fn notify(brightness: i32) -> Result<(), Box<dyn Error>> {
    let connection = Connection::session().await?;
    let proxy = BrightnessNotificationsProxy::new(&connection).await?;

    let mut hints = HashMap::new();
    let brightness_val = Value::new(brightness);
    hints.insert("value", &brightness_val);

    let _ = proxy
        .notify(
            "brightness",
            1,
            "",
            &format!("Brightness {}", brightness),
            "",
            &[],
            &hints,
            1000,
        )
        .await?;

    Ok(())
}
