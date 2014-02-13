/*global require*/
(function($){
  if ($) {
    // Removes stupid SEO links on www.lemonde.fr
    $('.lien_interne').replaceWith(function(){
      return this.childNodes;
    });
  }
})(require('lib/jquery'));
