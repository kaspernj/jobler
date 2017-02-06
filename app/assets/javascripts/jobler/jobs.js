function updateJobProgress() {
  console.log("updateJobProgress()")
  job = $(".job")

  $.ajax({type: "GET", url: job.data("job-path"), complete: function(data) {
    console.log(data.responseText)

    result = $.parseJSON(data.responseText)

    $(".job-headline").text(result.job.state_humanized)
    $(".progress-bar").text((result.job.progress * 100).toFixed(0) + "%")
    $(".progress-bar").css({width: (result.job.progress * 100) + "%"})

    if (result.job.state == "completed" || result.job.state == "error") {
      console.log("Job is completed - reload!")
      location.reload()
    }
  }})

  if (job.data("state") != "completed") {
    setTimeout("updateJobProgress()", 2000)
  }
}

$(document).ready(function() {
  job = $(".job")

  if (job.data("state") != "completed" && job.data("state") != "error") {
    setTimeout("updateJobProgress()", 1000)
  }
})
