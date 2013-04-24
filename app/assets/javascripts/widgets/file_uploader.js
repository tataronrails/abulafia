/* Simple Ajax File uploader
 * By Pavel Evstigneev pavel.evst@gmail.com
 */

var FileUploader = jClass.extend({
  files: [],
  toIgnore: [],

  init: function (element) {
    this.element = $(element);
    if (!this.isXhrUploadSupported()) {
      this.element.addClass('classic');
      return;
    }

    this.input = this.element.find('input[type=file]#pictures');
    this.droppable = this.element.parent(); //find('.droppable');
    this.list = this.element.find('ul.files');

    this.droppable.bind('drop', this.filesDropped.bind(this));
    this.input.bind('change', this.filesAdded.bind(this));

    this.droppable
      .on('drop', this.filesDropped.bind(this))
      .on('dragstart', this.filesDropped.bind(this))
      .on('dragenter', this.filesDropped.bind(this))
      .on('dragover', this.filesDropped.bind(this))
      .on('dragleave', this.filesDropped.bind(this));

    $(document)
      .on('drop', this.filesDropped.bind(this))
      .on('dragenter', this.filesDropped.bind(this))
      .on('dragover', this.filesDropped.bind(this))
      .on('dragleave', this.filesDropped.bind(this));
  },

  filesAdded: function (e) {
    e.preventDefault();
    e.stopPropagation();
    var files = this.input[0].files;
    for (var fnum = 0; fnum < files.length; fnum += 1) {
      if (this.files.indexOf(files[fnum]) == -1) {
        this.collectFile(files[fnum]);
      }
    }
    this.input[0].value = '';
    console.log('this.input.files', files.length, this.input[0].files);
  },

  filesDropped: function (event) {
    event.stopPropagation();
    event.preventDefault();
    //console.log(event, event.originalEvent.dataTransfer.files);
    if (event.type == 'drop') {
      var transferer = event.originalEvent.dataTransfer;
      for (var fnum = 0; fnum < transferer.files.length; fnum += 1) {
        if (this.files.indexOf(transferer.files[fnum]) == -1) {
          this.collectFile(transferer.files[fnum]);
        }
      }
    }

    /*
    if (event.type == 'dragenter' && event.target == this.droppable[0]) {
      this.droppable.css('background', '#fff8dc');
      console.log(event.target);
    }

    if (event.type == 'drop' || event.type == 'dragleave') {
      this.droppable.css('background', '');
    }
    */
  },

  collectFile: function (file) {
    if (this.toIgnore.indexOf(file) != -1) return;
    this.toIgnore.push(file);
    var found = false;
    this.files.forEach(function(f) {
      if (found) return;
      if (f == file || f.name == file.name && f.size == file.size && f.type == file.type) {
        found = true;
      }
    });

    if (!found) {
      if (file.type == 'image/jpeg' || file.type == 'image/png' || file.type == 'image/gif' || file.type == 'image/tiff' || 1) {
        this.files.push(file);
        new FileUploader.File(file, this);
      } else {
        alert("Файл " + file.name + " имеет недопустимый формат " + file.type + '. Пожалуйста выберите JPEG PNG или GIF файл');
      }
    }
  },

  isXhrUploadSupported: function() {
    var input = document.createElement('input');
    input.type = 'file';

    return (
      input.multiple !== undefined &&
        typeof File !== "undefined" &&
        typeof FormData !== "undefined" &&
        typeof (new XMLHttpRequest()).upload !== "undefined" );
  }
});

FileUploader.File = jClass.extend({
  init: function (fileObject, uploader) {
    this.fileObject = fileObject;
    this.uploader = uploader;
    this.appendToList();
    this.startUpload();
  },

  buildHtml: function () {
    /*
      %li
        %b logo1.png
        %span (114k)
        .progress
          .done{:style => 'width: 57%'}
        %a.delete
    */
    var progress = "<div class='upload-progress'><i class='icon-spinner icon-spin'></i><div class='done'></div></div>";
    var html = "<li><b>" + this.fileObject.name + "</b> <span>(" + Math.round(this.fileObject.size / 1024) + "k)</span>" +
      progress +
      "<a class='delete'><i class='icon-trash'></i></a>";
    return html;
  },

  buildDomNode: function () {
    this.element = $('<div>').html(this.buildHtml()).find('li');
    this.element.find('a.delete').bind('click', this.remove.bind(this));
    //this.progressBar = this.element.find('.progress .done');
    return this.element;
  },

  appendToList: function() {
    this.uploader.list.append(this.buildDomNode());
  },

  startUpload: function () {
    var xhr = jQuery.ajaxSettings.xhr();

    if (xhr.upload) {
      //xhr.upload.addEventListener('progress', this.onRequestProgress.bind(this), false);
    }

    var provider = function () { return xhr; };

    var data = new FormData();
    data.append('attachment[filename]', this.fileObject);

    if (this.uploader.element.attr('attachable_type')) {
      data.append('attachment[attachable_type]', this.uploader.element.attr('attachable_type'))
    }

    this.xhr = xhr;

    $.ajax({
      dataType: 'html',
      url: '/attachments',
      data: data,
      xhr: provider,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
      complete: function() {
        //console.log(arguments);
      },
      success: function(data) {
        var node = $('<div>').html(data).find(" > *");
        this.element.find('.upload-progress').replaceWith(node);
        //if (this.opts.success !== false) this.opts.success(data);
        //if (this.opts.preview === true) this.dropareabox.html(data);
      }.bind(this)
    });
    
  },

  onRequestProgress: function (e) {
    var percent = parseInt(e.loaded / e.total * 100, 10);
    this.progressBar.css('width', '' + percent + '%');
  },

  remove: function (e) {
    e && e.preventDefault();
    console.log(this.xhr, this.xhr.abort);
    this.xhr && this.xhr.abort();
    this.element.remove();
  }
});

FileUploader.init = function(node) {
  jQuery(node || document.body).find('[interaction="file-uploader"]').each(function(i, el) {
    new FileUploader(el);
  });
};