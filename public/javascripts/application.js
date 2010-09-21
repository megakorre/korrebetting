// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function JobbContext(args) {
  var jobs = args.jobs;
  var count = jobs.length;
  var items_prossesed = 0;
  
  function prossesJobb(job) {
    args.job(job, function() {
      items_prossesed += 1;
      args.progress(
        (items_prossesed / count) * 100);
      
      var job = jobs.pop();
      if(job !== undefined) {
        prossesJobb(job);
      } else {
        args.next();
      }
    });
  }
  var job = jobs.pop();
  if(job !== undefined) {
    prossesJobb(job);
  } else {
    args.next();
  }
}

var data = null;

$(function() {
  
  $("#show-settings").bind('click', function(event) {
    $("#options").slideToggle("fast");
  });
  
  $("#progressbar").progressbar({
  	value: 0,
  	animated: true
  });
  $("input:button").button();
  
  
  $("#download-games").click(function() {
    $(this).button( "disable" );
    $("#progressbar").slideDown("slow");
    $.getJSON('/games.json', 
      { date: $("#date").val(), 
        show_played_games: $("#played").is(":checked") ? "on": "off" }, 
      
      function(json, textStatus) {
        data = json;
        JobbContext({
          jobs: data.slice(),
          progress: function(p) {
            $("#progressbar").progressbar("value", p);
          },
          job: function(item, callback) {
            $.getJSON('/games/statistics.json', {match: item.matchid }, function(json, textStatus) {
              for(i in data) {
                if(data[i].matchid == item.matchid) {
                  if(json[0].home === null || json[0].away === null) {
                    delete data[i];
                  } else {
                    data[i].stats = json[0];
                  }
                }
              }
              callback();
            });
          },
          next: function() {
            $("#res").val($.toJSON(data));
            $("#download").submit();
          }
        });
    });
  });
});