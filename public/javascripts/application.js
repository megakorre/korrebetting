// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  var global_matches = null;
  var request_count = 0;
  var request_maid = 0;
  var xml = $("<data />");
  
  function suround(el) {
    return $("<div />").append($(el).clone()).html();
  }
  
  function done(args) {
    $("#res").val(suround(xml));
    $("#download").show();
  }
  
  function prosses_requests(matches) {
    $("#info").text("fetching statistics........ 0%");
    
    $(matches).each(function(index) {
      var container = $("<data />");
      var match = matches[index];
      for(var i = 0; i < match.length; i++) {
        $(container).append(
          $("<match />").attr("id", match[i])
        );
      }
      
      $.post('/games/statistics.xml', {matches: suround(container) }, function(data, textStatus, xhr) {
        request_maid++;
        $("#info").text("fetching statistics........ " + ((request_maid / request_count) * 100) + "%");
        if(request_count == request_maid) {
          done();
        }
      }, 'xml');      
    });
  }
  
  $("#download-games").click(function() {
    $("#info").text("fetching games...........");
    $.get('/games.xml', null, function(data, textStatus, xhr) {
      global_matches = data;
      var count = $(data).find("object").length;
      var matches = $(data).find("object").map(function(index, elem) {
        return $(this).find("matchid").text();
      }).toArray();
      
      var res = [];
      for (var i = 0; i < count; i = i + 5) {
        res.push(matches.slice(i, i + 5));
      }
      request_count = res.length;
      prosses_requests(res);
    }, 'xml');
    
    
    return false;
  });
  
  
});