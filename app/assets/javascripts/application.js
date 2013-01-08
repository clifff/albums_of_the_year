// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//
//
function submitUsername(){
  var username = jQuery('#username_field').val();
  window.location.href = "/lastfm/" + username;
}

function setAlbumArtHeight(){
  $('.albumart').each(function(){
    $(this).css('height',$(this).width()+'px');
  });
}

function pollIfReady(url){
  window.setInterval(function(){
    jQuery.getJSON(url, function(pageReady){
      if (pageReady){
        window.location.reload();
      }
    });
  }, 5000);
}

$(document).ready(function(){
  if (!!window.polling_url){
    pollIfReady(window.polling_url);
  }
  setAlbumArtHeight();
  $(window).resize(setAlbumArtHeight);
});
