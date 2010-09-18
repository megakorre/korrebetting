// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function JobbContext(args) {
  var jobs = args.jobs;
  
  function prossesJobb(job) {
    args.job(job, function() {
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
  
  $("#download-games").click(function() {
    $.getJSON('/games.json', {}, function(json, textStatus) {
      data = json;
      JobbContext({
        jobs: data.slice(),
        job: function(item, callback) {
          $.getJSON('/games/statistics.json', {match: item.matchid }, function(json, textStatus) {
            for(i in data) {
              if(data[i].matchid == item.matchid) {
                data[i].stats = json[0];
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