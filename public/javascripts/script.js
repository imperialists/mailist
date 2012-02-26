jQuery(function($){
  $('.bar').mosaic({
	  animation	:	'slide'		//fade or slide
  });

  $('#groups').height(Math.max($('#threads').height(),$('#groups').height()));
  displayPinnedThreads();
  displaySubscriptions();
});

function displaySubscriptions() {
	 var divs = [];
     $.getJSON('/subscribed', function(data) {
       $.each(data, function(key, label) {
        // REPLACE HASH WITH THE ADRESS OF A BROWSING PAGE
       var div = "<a class=\"menu\" href=\"label.html?label=" + label + "\">" + label + "</a><br />";
       divs.push(div);
     });
     $('#groups').prepend(divs.join());
     $('#groups').prepend("<h4 style=\"margin-top: 3px\">Groups</h4>");
  });
}

function displayPinnedThreads() {
  var thread_list = [];
  var comment_list = [];
  var tid = 0;
  $.getJSON('/pinned', function(data) {
    $.each(data, function(key, thread) {

      var comment = "<div class=\"highslide-html-content\" id=\"thread-" + tid + "\">";
      comment += "<div class=\"highslide-header\">";
      comment += "<ul>";
	    comment += "<li class=\"highslide-close\">";
		  comment += "<a href=\"#\" onclick=\"return hs.close(this)\"><img src=\"images/close.jpg\" alt=\"move\" /></a>";
	    comment += "</li>";
      comment += "</ul>";
      comment += "</div>";
      comment += "<div class=\"highslide-body\">";

      comment += "<div class=\"row\">";
      comment += "<div class=\"picture\"><img src=\"images/big.jpg\" alt=\"\" width=\"200\" height=\"160\" /></div>";
      comment += "<div class=\"wrapper\">";
      comment += "<h1>Haskell lecture</h1>";
      comment += "<p class=\"separator\">&nbsp;</p>";
      comment += "<input type=\"text\" placeholder=\"Subject\" />";
      comment += "<textarea placeholder=\"Type your message. Slowly.\"></textarea>";
      comment += "<p class=\"submit\">Characters: 24, Words: 4 <input type=\"submit\" value=\"submit\" /></p>";
      comment += "</div>";
      comment += "<div class=\"clearfix\"></div>";
      comment += "</div>";
          
      $.each(thread.messages, function(key3, message) {
        comment += "<div class=\"row-small\">";
        comment += "<div class=\"picture-small\"><img src=\"images/big.jpg\" alt=\"\" width=\"50\" height=\"40\" /></div>";
        comment += "<div class=\"wrapper-small\">";
        comment += "<h4>No Haskell lecture on Friday, 09 February</h4>";
        comment += "<p>" + message.body + "</p>";
        comment += "</div>";
        comment += "<div class=\"clearfix\"></div>";
        comment += "</div>";
      });

      comment += "</div></div>";
      comment_list.push(comment);
          

      var div = "<div class=\"mosaic-block bar\"><a href=\"#\" class=\"highslide mosaic-overlay\" onclick=\"return hs.htmlExpand(this, { contentId: 'thread-" + tid + "' } )\"><div class=\"details\"><h4>Haskell Lecture</h4><p>Messages: #3<br />Pins: #10<br />Likes: #7<br />Last discussed: 13/03/2012</p><input type=\"button\" value=\"Pin\" /><input type=\"button\" value=\"Like\" /><input type=\"button\" value=\"Comment\" /></div></a><div class=\"mosaic-backdrop\"><img src=\"http://buildinternet.s3.amazonaws.com/projects/mosaic/mightyicons.jpg\" /></div></div>";
      thread_list.push(div);
      tid++;
    });
    $('#t').html(thread_list.join());
    $('#c').html(comment_list.join());
  });
}