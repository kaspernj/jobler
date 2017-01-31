function updateJobProgress() {
  console.log("updateJobProgress()")
  job = $(".job")

  $.ajax({type: "GET", url: job.data("job-path"), complete: function(data) {
    console.log(data.responseText)

    result = $.parseJSON(data.responseText)

    $(".job-progress").text((result.job.progress * 100).toFixed(2) + "%")

    if (result.job.state == "completed") {
      console.log("Job is completed - reload!")
      location.reload()
    }
  }})

  if (job.data("state") != "completed") {
    setTimeout("updateJobProgress()", 5000)
  }
}

$(document).ready(function() {
  job = $(".job")

  if (job.data("state") != "completed") {
    updateJobProgress()
  }
})
