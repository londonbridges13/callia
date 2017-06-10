//= require iCheck/icheck.min.js
//= require steps/jquery.steps.min.js
//= require validate/jquery.validate.min.js
//= require dropzone/dropzone.js
//= require summernote/summernote.min.js
//= require colorpicker/bootstrap-colorpicker.min.js
//= require cropper/cropper.min.js
//= require datapicker/bootstrap-datepicker.js
//= require ionRangeSlider/ion.rangeSlider.min.js
//= require jasny/jasny-bootstrap.min.js
//= require jsKnob/jquery.knob.js
//= require nouslider/jquery.nouislider.min.js
//= require switchery/switchery.js
//= require chosen/chosen.jquery.js
//= require fullcalendar/moment.min.js
//= require clockpicker/clockpicker.js
//= require daterangepicker/daterangepicker.js
//= require select2/select2.full.min.js
//= require touchspin/jquery.bootstrap-touchspin.min.js
//= require bootstrap-markdown/bootstrap-markdown.js
//= require bootstrap-markdown/markdown.js
//= require bootstrap-tagsinput/bootstrap-tagsinput.js
//= require dualListbox/jquery.bootstrap-duallistbox.js
//= require typehead/bootstrap3-typeahead.min.js
//= require codemirror/codemirror.js
//= require codemirror/mode/javascript/javascript.js







function display_client(name, id) {
  document.getElementById('client_name').innerHTML = name;
  // display_client_activities();//["james\nklk","jackie\nhi","whack \na \nmole"]);
  find_selected_client(id);
}

function display_client_activities(activities) {
  ul = document.getElementById('client_activity');
  ul.innerHTML = '';
  activities.forEach(function generateList(activity){

    var li = document.createElement('li');
    li.className = "nav-item";
    // ul.appendChild(li);

    // var vt = document.createElement('div');
    // vt.className = "vertical-container dark-timeline";
    // vt.id = "vertical-timeline";
    // li.append(vt);

    var vtb = document.createElement('div');
    vtb.className = "vertical-timeline-block";
    // vt.append(vtb);

    var vti = document.createElement('div');
    vti.className = "vertical-timeline-icon gray-bg";
    // vtb.append(vti);

    var i = document.createElement('i');
    i.className = "fa fa-briefcase";
    // vti.append(i);

    var vtc = document.createElement('div');
    vtc.className = "vertical-timeline-content";
    // vtb.append(vtc);

    var p = document.createElement('p');
    p.innerHTML = activity[0];// + gon.clients_info;

    var span = document.createElement('span');
    span.className = "vertical-date small text-muted";
    span.append(activity[1]);

    vtc.append(p);
    vtc.append(span);
    vtb.append(vtc);
    vti.append(i);
    vtb.append(vti);
    li.append(vtb);
    // li.append(vt);
    var br = document.createElement('br');
    ul.append(br);
    ul.appendChild(li);
  });

}


function find_selected_client(id){
  // Find the client so that you can display client in the sidebar
  // search through  gon.clients_info array
  ul = document.getElementById('client_activity');
  ul.innerHTML = '';
  var selected_client =
  gon.clients_info.forEach(function generateList(client){
    if (client[0] == id){// this works
      if (Array.isArray(client[4])){
        display_client_activities(client[4]);
        set_edit_button(id);
      }
      if (client[2]!= ""){
        document.getElementById('about_client').innerHTML = client[2];
      }

      if (client[3]!= ""){
        document.getElementById('cnotes').innerHTML = client[3];
      }
      // set the edit button link

    }
  });
}

function set_edit_button(id){
  var a = document.getElementById("edit_button")
  a.href = "/clients/"+id+"/edit";
  // a.type = "button"
  // a.className = "btn btn-success btn-sm btn-block"
  //
  // var span = document.getElementById('span_edit_button')
  // span.className = "pull-left";

}
