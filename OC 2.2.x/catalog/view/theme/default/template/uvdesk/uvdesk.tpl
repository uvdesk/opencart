<?php echo $header; ?>
<div class="container">
  <ul class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
    <?php } ?>
  </ul>
  <?php if ($success) { ?>
  <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?></div>
  <?php } ?>
  <?php if ($warning) { ?>
  <div class="alert alert-danger"><i class="fa fa-exclamation-triangle"></i> <?php echo $warning; ?></div>
  <?php } ?>
  <div class="row"><?php echo $column_left; ?>
    <?php if ($column_left && $column_right) { ?>
    <?php $class = 'col-sm-6'; ?>
    <?php } elseif ($column_left || $column_right) { ?>
    <?php $class = 'col-sm-9'; ?>
    <?php } else { ?>
    <?php $class = 'col-sm-12'; ?>
    <?php } ?>
    <div id="content" class="<?php echo $class; ?>"><?php echo $content_top; ?>
      <div class="col-sm-3">
        <div class="panel panel-default">
          <div class="panel-heading"><h3 class="panel-title"><?php echo $heading_collab; ?></h3></div>
          <div class="panel-body">
            <div id="collaborator-panel">
              <?php if(isset($ticket->collaborators) && $ticket->collaborators) { ?>
              <?php foreach ($ticket->collaborators as $collaborator) { ?>
              <div class="coll-div">
                <?php if ($collaborator->smallThumbnail) {
                  $col_image = $collaborator->smallThumbnail;
                } else {
                  $col_image = 'https://cdn.uvdesk.com/uvdesk/images/d94332c.png';
                } ?>
                <img src="<?php echo $col_image; ?>" class="img-responsive pull-left">
                <span>
                  <?php if (isset($collaborator->detail->agent)) {
                    echo $collaborator->detail->agent->name;
                  } else {
                    echo $collaborator->detail->customer->name;
                  } ?>
                </span>
                <div class="pull-right removeCollaborator" col-id="<?php echo $collaborator->id; ?>"><i class="fa fa-trash"></i></div>
              </div>
              <?php } ?>
              <?php } else echo $text_no_collab; ?>
            </div>
            <div class="collab-input">
              <input type="text" placeholder="<?php echo $entry_add_collab; ?>" class="form-control" id="addCollaborator">
            </div>
          </div>
        </div>
      </div>
      <div class="panel panel-default col-sm-9">
        <div id="ticket-detail">
          <h4>
            #<?php 
            if (isset($ticket->incrementId)) {
              echo $ticket->incrementId . " ";
            }
            if (isset($ticket->subject)) {
              echo $ticket->subject;
            }
             ?>
          </h4>
          <div class="ticket-labels">
            <span class="label label-default"><?php echo $ticket->formatedCreatedAt; ?></span>
            <?php if (isset($ticket->status->id)) { ?>
            <span class="label label-default" title="Threads" data-toggle="tooltip"><?php echo $ticketTotalThreads; ?> Replies</span>
            <?php } ?>
            <?php if (isset($ticket->type->id)) { ?>
            <span class="label label-default" title="Type" data-toggle="tooltip"><?php echo $ticket->type->name; ?></span>
            <?php } ?>
            <span class="label label-default" title="Status" data-toggle="tooltip"><?php echo $ticket->status->name; ?></span>
          </div>
        </div>
        <div class="thread">
          <div class="col-sm-12 thread-created-info text-center">
            <span class="info">
            <?php if (isset($ticket->customer->detail->customer->id)) {
              $customer_name = $ticket->customer->detail->customer->name;
              echo $customer_name;
            } else {
              $customer_name = '';
            } ?>
              <?php echo $text_created; ?>
            </span>
            <span class="text-right date pull-right">
              <?php if (isset($ticket->formatedCreatedAt)) {
                echo $ticket->formatedCreatedAt;
              } ?>
            </span>
          </div>
          <div class="col-sm-12">
            <div class="pull-left">
              <span class="round-tabs">
                <img src="<?php if (isset($ticket->customer->profileImage)) { echo $ticket->customer->profileImage; } else { echo "https://cdn.uvdesk.com/uvdesk/images/d94332c.png"; } ?>">
              </span>
            </div>
            <div class="thread-info">
              <div class="thread-info-row first">
                <span class="cust-name">  
                  <strong><?php echo $customer_name; ?></strong>
                </span>
              </div>
              <div class="thread-info-row">
              </div>
            </div>
            <div class="thread-body">
              <div class="reply border-none">
                <div class="main-reply">
                  <?php if (isset($ticket_reply)) {
                    echo $ticket_reply;
                  } ?>
                </div>
                <?php if (isset($attachments) && $attachments) { ?>
                  <?php foreach ($attachments as $attachment) { ?>
                    <a href="<?php echo $attachment_url . $attachment->id; ?>" target="_blank" class="download-attachment"><i class="fa fa-download"></i></a>
                  <?php } ?>
                <?php } ?>
              </div>
            </div>
          </div>
        </div>

        <div class="text-center load-div">
          <button class="btn btn-primary" id="button-load"></button>
          <span class="loader-border"></span>
        </div>

        <div class="ticket-thread">
        </div>
        <hr>
        <div class="col-sm-12">
          <div class="pull-left">
            <span class="round-tabs">
              <?php if (isset($ticket->customer->profileImage) && $ticket->customer->profileImage) { ?>
              <img src="<?php echo $ticket->customer->profileImage; ?>">              
              <?php } else { ?>
              <img src="https://cdn.uvdesk.com/uvdesk/images/d94332c.png">
              <?php } ?>
            </span>
          </div>
          <span class="customerName"><?php echo $ticket->customer->detail->customer->name; ?></span>
          <div class="thread-body">
            <div class="thread-info">
              <form action="<?php echo $add_reply; ?>" method="post" enctype="multipart/form-data">
                <div class="reply border-none" style="padding: 0;">
                  <textarea class="summernote" name="reply"></textarea>
                  <input type="hidden" name="ticket_id" value="<?php echo $thread_id; ?>">
                  <input type="hidden" name="id" value="<?php echo $id; ?>">
                  <div class="attachment-div">
                    <span class="download-attachment upload-attachment"><i class="fa fa-upload"></i><span onclick="$(this).parent().parent().remove();">&times;</span></span>
                    <input type="file" name="attachment[]" class="fileUpload" style="display: none;" onchange="validate_fileupload(this);">
                  </div>
                  <span id="addFile">+ <?php echo $text_attach; ?></span>
                  <br><br>
                  <input type="submit" class="btn btn-success" value="Reply">
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      <?php echo $content_bottom; ?></div>
    <?php echo $column_right; ?></div>
</div>
<link href="catalog/view/theme/default/stylesheet/uvdesk/view.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
  var current_page = 0;
  var last_page = 0;
  var inprocess = 0;
  var scrollDown = 1;

  $('#moreLabel').on('click', function () {
    $('.showLabel').slideToggle();
  });

  function loadThreads() {
    var next_page = parseInt(current_page) + 1;
    
    $.ajax({
      url: 'index.php?route=uvdesk/uvdesk/getThreads',
      dataType: 'json',
      type: 'post',
      data: {id: '<?php if (isset($thread_id)) echo $thread_id; else echo ""; ?>', page: next_page},
      beforeSend: function () {
        $('#button-load').html('<i class="fa fa-spin fa-spinner"></i>');
        $('#button-load').addClass('disabled');
        inprocess = 1;
      },
      success: function (json) {
        var threads = '';
        if (json['threads']) {
          var jsonThreads = json['threads'];
          for (var i = 0; i < jsonThreads.length; i++) {
            var threads = '';
            threads += '<div class="thread">';
            threads += '  <div class="col-sm-12 thread-created-info text-center">';
            threads += '    <span class="info">';
            threads += '      <span id="thread' + jsonThreads[i]['thread_id'] + '" class="copy-thread-link">#' + jsonThreads[i]['thread_id'] + '</span>';
            threads += '      ' + jsonThreads[i]['name'];
            threads += '      <?php echo $text_replied; ?>';
            threads += '    </span>';
            threads += '    <span class="text-right date pull-right">';
            threads += jsonThreads[i]['date_added'];
            threads += '    </span>';
            threads += '  </div>';
            threads += '  <div class="col-sm-12">';
            threads += '    <div class="height-10">';
            threads += '      <div class="pull-left">';
            threads += '        <span class="round-tabs">';
            threads += '          <img src="' + jsonThreads[i]['thumbnail'] + '">';
            threads += '        </span>';
            threads += '      </div>';
            threads += '      <div class="thread-info">';
            threads += '        <div class="thread-info-row first">';
            threads += '          <span class="cust-name">  ';
            threads += '            <strong>' + jsonThreads[i]['name'] + '</strong>';
            threads += '          </span>';
            if (jsonThreads[i]['user_type']) {
              threads += '          <label class="user-type customer label label-info">';
              threads += jsonThreads[i]['user_type'];
              threads += '          </label>';
            }
            threads += '        </div>';
            threads += '        <div class="thread-info-row">';
            threads += '        </div>';
            threads += '      </div>';
            threads += '    </div>';
            threads += '    <div class="thread-body">';
            threads += '      <div class="reply">';
            threads += '        <div class="main-reply">';
            threads += '          ' + jsonThreads[i]['reply'];
            threads += '        </div>';
            threads += '      </div>';
            var attachment_length = Object.keys(jsonThreads[i]['attachments']).length;
            if (attachment_length) {
              threads += '<div class="attachments">';
              for (var j = 0; j < attachment_length; j++) {
                threads += '<a href="<?php echo $attachment_url; ?>' + jsonThreads[i]['attachments'][j]['id'] + '" target="_blank" class="download-attachment"><i class="fa fa-download"></i></a>';
              }
              threads += '</div>';
            }
            threads += '    </div>';
            threads += '  </div>';
            threads += '</div>';
            threads += '<hr>';
            $('.ticket-thread').prepend(threads);
          }
        }
        current_page = json['current_page'];
        last_page = json['last_page'];
        if (current_page == last_page) {
          $('#button-load').text('<?php echo $text_all_expand; ?>');
        } else {
          var threads_left = json['total'] - (10 * current_page);
          $('#button-load').text('<?php echo $text_expand; ?> ' + threads_left + ' <?php echo $text_more; ?>');
        }
        inprocess = 0;
        if (scrollDown) {
          var docheight = ($(document).height() - $(window).height() - 300);
          $('html, body').animate({ scrollTop: docheight }, 'slow');
          scrollDown = 0;
        }
      },
      complete: function () {
        $('#button-load').removeClass('disabled');
      },
      error: function () {
        location.reload();
      }
    });
  }

  $('#button-load').on('click', function () {
    if (!inprocess && last_page > current_page) {
      loadThreads();
    }
  })

  loadThreads();

  $('#addCollaborator').on('keyup', function (e) {
    if ((e.which == 13) && !inprocess) {
      var thisthis = $(this);
      var col_email = thisthis.val();
      $('.text-danger').remove();
      if (!(col_email == '') && validateEmail(col_email)) {
        $.ajax({
          url: 'index.php?route=uvdesk/uvdesk/addCollaborator',
          dataType: 'json',
          type: 'post',
          data: {id: '<?php if (isset($thread_id)) echo $thread_id; else echo ""; ?>', email: col_email},
          beforeSend: function () {
            inprocess = 1;
          },
          success: function (json) {
            if (json['success']) {
              var append_coll = '';
              append_coll += '<div class="coll-div">';
              append_coll += '  <img class="img-responsive pull-left" src="' + json['image'] + '">';
              append_coll += '  <span>' + json['name'] + '</span>';
              append_coll += '  <div class="pull-right removeCollaborator" col-id="' + json['id'] + '">';
              append_coll += '    <i class="fa fa-trash"></i>';
              append_coll += '  </div>';
              append_coll += '</div>';
              if (!($('#collaborator-panel').children().hasClass('coll-div'))) {
                $('#collaborator-panel').html('');
              }
              $('#collaborator-panel').append(append_coll);
              thisthis.after('<div class="text-success padding-5">' + json['success'] + '</div>');
              setTimeout(
                function () {
                  $('.text-success').fadeOut('slow');
                },
              5000);
              thisthis.val('');
            }
            if (json['error']) {
              thisthis.parent().addClass('has-error');
              thisthis.after('<div class="text-danger padding-5">' + json['error'] + '</div>');
              setTimeout(
                function () {
                  thisthis.parent().removeClass('has-error');
                  $('.text-danger').fadeOut('slow');
                },
              5000);
            }
            inprocess = 0;
          },
          error: function () {
            thisthis.parent().addClass('has-error');
            thisthis.after('<div class="text-danger" style="margin-left: 5px;">There seems to be some error while adding collaborator</div>');
          }
        });
      } else {
        thisthis.parent().addClass('has-error');
        thisthis.after('<div class="text-danger" style="margin-left: 5px;">Please enter a valid email</div>');
        setTimeout(
          function () {
            thisthis.parent().removeClass('has-error');
            $('.text-danger').fadeOut('slow');
          },
        5000);
      }
    }
  });

  $('body').on('click', '.removeCollaborator', function () {
    var thisthis = $(this);
    var col_id = thisthis.attr('col-id');
    if (!(col_id == '')) {
      var coll_html = '';
      $.ajax({
        url: 'index.php?route=uvdesk/uvdesk/removeCollaborator',
        dataType: 'json',
        type: 'post',
        data: {id: '<?php if (isset($thread_id)) echo $thread_id; else echo ""; ?>', col_id: col_id},
        beforeSend: function () {
          coll_html = thisthis.parent().html();
          thisthis.parent().fadeOut('slow');
        },
        success: function (json) {
          if (json['success']) {
            $('#addCollaborator').after('<div class="text-success padding-5">' + json['success'] + '</div>');
            setTimeout(
              function () {
                $('.text-success').fadeOut('slow');
              },
            5000);
            thisthis.parent().remove();
            if ($('#collaborator-panel').html() == '') {
              $('#collaborator-panel').text('There is no collaborator available for this ticket.');
            }
          }
          if (json['error']) {
            thisthis.parent().fadeIn('slow');
            $('#addCollaborator').after('<div class="text-danger padding-5">' + json['error'] + '</div>');
            setTimeout(
              function () {
                $('.text-danger').fadeOut('slow');
              },
            5000);
          }
        },
        error: function () {
           thisthis.parent().fadeIn('slow');
        }
      });
    }
  });

  function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  $('body').on('click', '.upload-attachment', function () {
    var child = $(this).next('.fileUpload');
    child.trigger('click');
  });

  function validate_fileupload(thisthis) {
    var size = thisthis.files[0].size/1000;
    var limit = 1;
    var max = 10;
    var maxsize = 300000;
    if(thisthis.type == 'file') {
      fileName = thisthis.value;
      var file_extension = fileName.split('.').pop(); 
      if(size < maxsize) {
        var getImagePath = URL.createObjectURL(thisthis.files[0]);
        $(thisthis).prev().css('background-image', 'url(' + getImagePath + ')');
        $(thisthis).prev().css('background-size', 'cover');
        // $(thisthis).prev().append('<span class="ex">' + file_extension + '</span>');
        limit++;
        return true; 
      }
    }
    if(limit > max)
      alert('Maximum Number of file is '+max);
    else
      alert("invalid file type or size");
      thisthis.value = "";
      return false;
  };

  $('#addFile').on('click', function () {
    var attach = '<div class="attachment-div"><span class="download-attachment upload-attachment"><i class="fa fa-upload"></i><span onclick="$(this).parent().parent().remove();">&times;</span></span><input type="file" name="attachment[]" class="fileUpload" style="display: none;" onchange="validate_fileupload(this);"></div>';
    $(this).before(attach);
  });


$(document).ready(function() {
  $('.summernote').summernote({
    height: 230,
    onImageUpload: function(files, editor, $editable) {
      sendFile(files[0],editor,$editable);
    },
  });
});

function sendFile(file,editor,welEditable) {
  data = new FormData();
  data.append("file", file);
  $.ajax({
    url: "index.php?route=uvdesk/uvdesk/uploadSummernoteImage",
    data: data,
    cache: false,
    contentType: false,
    processData: false,
    type: 'POST',
    success: function(data){
      if (data.image) {
        editor.insertImage(welEditable,data.image);
      }else{
         alert(data.error);
      };
    },
    error: function(jqXHR, textStatus, errorThrown) {
      console.log(textStatus+" "+errorThrown);
    }
  });
}
</script>
<?php echo $footer; ?> 