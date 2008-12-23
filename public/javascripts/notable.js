var Notable = {}

Notable.Page = Class.create();
Notable.Page.prototype = {

  initialize: function(){
    this.MaxZIndex = 0;
    this.notes = [];
  },

  render_page: function(){
    $$(".note").each(function(item,i){
      var note = new Notable.Note($(item));
      note.load(i);
    })          
  },
  
  add_note: function(){
      var note = new Notable.Note($$(".note")[0])
      note.load(1);
  },
  
  retrieve_note: function(id){
    var target;
    this.notes.each(function(item, i){
      if (item.id == id){
        target = item;
      }
    }    
    )
    return target;
  },

  remove_note: function(id){
    this.notes = this.notes.reject(function(item){
      return item.id == id;
    })
  }
};



Notable.Note = Class.create();
Notable.Note.prototype = {
  initialize: function(elem){
    this.element = elem;
    this.id = elem.id;
  },  
  load: function(i){
    var note = this;
    setTimeout(function(){new Effect.Appear(note.element,{duration:0.3})}, i * 100);
    new Draggable(note.element,{onStart: function(){Notable.page.retrieve_note(note.id).start_drag();}, onEnd: function(){note.drop()}});    
    note.element.setStyle({position:"absolute", top: $(note.element).down(".noteY").innerHTML+"px",left: $(note.element).down(".noteX").innerHTML+"px",zIndex: $(note.element).down(".noteZ").innerHTML});
    if(parseInt(note.element.down(".noteZ").innerHTML) > Notable.page.MaxZIndex)
    {
      Notable.page.MaxZIndex = note.element.down(".noteZ").innerHTML
    }
    Notable.page.notes.push(note)
  },
  start_drag: function(){
    var note = this;
    Notable.page.MaxZIndex++;
    note.element.setStyle({zIndex: Notable.page.MaxZIndex})
  },  
  drop: function(){
    var note = this;
    new Ajax.Request("/notes/update_position/" + note.element.down(".noteId").innerHTML,
      {
        method: "get",
        parameters: {x:Position.cumulativeOffset(note.element)[0], y:Position.cumulativeOffset(note.element)[1], z: Notable.page.MaxZIndex}
      }
    );
  },
  
  toggle_area: function(area){
    switch(area){
    case "file_upload":
      var file_upload_area = $("add_file_" + this.id);
      var access_link = $("add_file_link_" + this.id);
      if(file_upload_area.style.display == 'none')
      {
        new Effect.Appear(file_upload_area, {duration: .2});
        access_link.innerHTML = "done";
      }
      else
      {
        new Effect.Fade(file_upload_area, {duration: .2})
        access_link.innerHTML = "add a file";      
      }
      break;
    }
  }

};

Notable.init = function(){
  Notable.page = new Notable.Page()
  Notable.page.render_page();
}

Event.observe(window, 'load', function() {
  Notable.init();
});