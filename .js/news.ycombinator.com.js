/*global window, document */
// Collapsible comments for Hacker News
(function() {
  "use strict";

  if (document.body.classList.contains('collapsible-comments')) return;
  document.body.classList.add('collapsible-comments');

  // Utils
  function parentElement(elt, parentName) {
    var parent = elt.parentNode;
    if (parent.tagName.toLowerCase() !== parentName.toLowerCase()) {
      return parentElement(parent, parentName);
    }
    return parent;
  }
  function nextAll(elt, stopTest) {
    var elts = [];
    while ( (elt = elt.nextElementSibling) && (!stopTest || stopTest(elt))) {
      elts.push(elt);
    }
    return elts;
  }

  // Get the first level comments
  function firstLevelHeads() {
    var elts = document.querySelectorAll('center > table > tbody > tr:nth-child(3) > td > table:nth-of-type(2) > tbody > tr td:first-child img[width="0"]');
    var heads = [];
    for (var i = 0; i < elts.length; i++) {
      heads.push(elts[i].parentNode.parentNode.querySelector('.comhead'));
    }
    return heads;
  }

  // Get nested comments
  function nestedComs(button) {
    var row = parentElement(parentElement(button, 'tr'), 'tr');
    var nested = nextAll(row, function(tr) {
      return !tr.querySelector('td > table > tbody > tr > td > img[width="0"]');
    });
    nested.push(button.parentNode.parentNode.nextElementSibling.nextElementSibling);
    return nested;
  }

  // Collapse a comments thread
  function collapse(button) {
    var coms = nestedComs(button);
    for (var i=0; i < coms.length; i++) {
      coms[i].style.display = 'none';
    }
    button.textContent = '+';
  }

  // Expand a comments thread
  function expand(button) {
    var coms = nestedComs(button);
    for (var i=0; i < coms.length; i++) {
      coms[i].style.display = 'block';
    }
    button.textContent = '-';
  }

  var comHeads = null;

  if (window.location.href.indexOf('item?id=') > -1) {
    comHeads = firstLevelHeads();
  }
  // TODO: user page
  // if (window.location.href.indexOf('threads?id=') > -1) {
  //   selector = 'center > table > tbody > tr > td > table span.comhead';
  // }

  if (!comHeads || !comHeads.length) return;

  function initButton(button){
    button.style.cursor = 'pointer';
    button.style.marginLeft = '10px';
    button.textContent = '-';
    button.addEventListener('click', function(){
      if (this.textContent == '-') {
        collapse(this);
      } else {
        expand(this);
      }
    }, false);
  }
  for (var i=0; i < comHeads.length; i++) {
    initButton(comHeads[i].appendChild(document.createElement('button')));
  }

})();
