var width = 850,
    height = 600,
    root;

var force = d3.layout.force()
    .linkDistance(function(d) {
      return 20;
      //console.log(d.target.name.length*2 + 20)
      //return d.target.name.length*2 + 40
    })
    .charge(function(d) {
      if (d.id==node[0].length) {
        console.log('set center')
        return -3500; 
      }else{
        return -3500;
      }
      //console.log(Math.pow( d.name.length, 2) * -10)
      //return Math.pow( d.name.length, 2) * -10
    })
    .gravity(.1)
    .size([width, height])
    .on("tick", tick);

var svg = d3.select("svg")
    .attr("width", width)
    .attr("height", height);

var link = svg.selectAll(".link"),
    node = svg.selectAll(".node");

d3.json("data.json", function(error, json) {
  root = json;
  update();
  function toggleAll(d) {
    if (d.children) {
      d.children.forEach(toggleAll);
      toggle(d);
    }
  }
  root.children.forEach(toggleAll); //so it starts collapsed
  update();
});

function update() {
  var nodes = flatten(root),
      links = d3.layout.tree().links(nodes);

  // Restart the force layout.
  force
      .nodes(nodes)
      .links(links)
      .start();

  // Update links.
  link = link.data(links, function(d) { return d.target.id; });

  link.exit().remove();

  link.enter().insert("line", ".node")
      .attr("class", "link");

  // Update nodes.
  node = node.data(nodes, function(d) { return d.id; });

  node.exit().remove();

  var nodeEnter = node.enter().append("g")
      .attr("class", "node")
      .on("click", click)
      //.on("mouseover", function(d) {showPopup(d)})
      .call(force.drag);

  nodeEnter.append("ellipse")
      .attr("rx", function(d) { return d.name.length*6})
      .attr("ry", 15);

  nodeEnter.append("text")
      .attr("dy", ".35em")
      .text(function(d) { return d.name; });

  node.select("ellipse")
      //.style("fill", color);
      .attr("class", classSetter);

  $("svg").hoverIntent({
    over: showPopup,
    out: function(){console.log("out");},
    selector: '.node'
  });
}

//if the popup is already in the top 5 don't add it again
var popupList = [-1,-1,-1];

function showPopup () {
  var d = this.__data__;
  if (popupList.indexOf(d.id) == -1){ //not in there...
    popupList.unshift(d.id);
    popupList.pop(); // so the list is alway only 3

    var el = $('<div class="info"></div>');
    if (d.type == 'word') {
      el.addClass('wordy');
    }else{
      el.addClass('rooty');
    }
    var term = $('<span class=term></span>').text(d.name + ": ")
    var def = $('<span class=def></span>').text(d.meaning)
    el.append(term)
    el.append(def)
    $('#infoinfo').prepend(el)
    el.toggle();
    el.slideDown()
  }else{
    //do nothing
  }
}

function tick() {
  link.attr("x1", function(d) { return d.source.x; })
      .attr("y1", function(d) { return d.source.y; })
      .attr("x2", function(d) { return d.target.x; })
      .attr("y2", function(d) { return d.target.y; });
  node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
}

function classSetter (d) {
  return d._children ? "collapsed"
      : d.children ? "expanded"
      : "leaf";
}

function color(d) {
  return d._children ? "#3182bd" // collapsed package
      : d.children ? "#c6dbef" // expanded package
      : "#fd8d3c"; // leaf node
}

// Toggle children on click.
function click(d) {
  if (d3.event.defaultPrevented) return; // ignore drag
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
  //this fixes middle element
  $.each(node.data(), function(index,n) {
    n.fixed = false;
  });
  node.transition().attr("transform", "translate("+width/2+","+height/2+")")
  d.fixed = true;
  d.x = d.px = width/2;
  d.y = d.py = height/2;
  tick();
  update();
}

function toggle(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
}

// Returns a list of all nodes under the root.
function flatten(root) {
  var nodes = [], i = 0;

  function recurse(node) {
    if (node.children) node.children.forEach(recurse);
    if (!node.id) node.id = ++i;
    nodes.push(node);
  }

  recurse(root);
  return nodes;
}
