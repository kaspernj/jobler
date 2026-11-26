function updateJobProgress() {
  var job = $(".job");

  $.ajax({type: "GET", url: job.data("path"), complete: function(data) {
    var result = $.parseJSON(data.responseText);
    var percentage = Math.round(result.job.progress * 100);

    $(".job-headline").text(result.job.headline);
    $(".progress-bar").text(percentage + "%");
    $(".progress-bar").css({width: percentage + "%"});
    $(".progress-bar").attr("aria-valuenow", percentage);

    if (result.job.progress_total_count > 0) {
      $(".progress-current-count").text(result.job.progress_current_count);
      $(".progress-total-count").text(result.job.progress_total_count);
    }

    if (result.job.state === "completed" || result.job.state === "error") {
      location.reload();
    }
  }});

  if (job.data("state") !== "completed") {
    setTimeout(updateJobProgress, 2000);
  }
}

$(document).ready(function() {
  var job = $(".job");

  if (job.data("state") !== "completed" && job.data("state") !== "error") {
    setTimeout(updateJobProgress, 1000);
  }
});
