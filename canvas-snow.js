//RequestAnimationFrame shim courtesy of Paul Irish. http://paulirish.com
if(!window.requestAnimationFrame){
  window.requestAnimationFrame = (function(){
    return window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.oRequestAnimationFrame ||
    window.msRequestAnimationFrame ||
    function(callback, element){
      window.setTimeout( callback, 1000 / 60 );
    };
  })();
}

function CanvasSnow(canvas, settings){
  this.canvas = canvas;
  this.context = canvas.getContext('2d');
  this.settings = settings;
  this.framerate = new FrameRate();

  this.init();

  setInterval(function(This){
    This.flakeLogic();
  }, 50, this);
}

CanvasSnow.prototype.init = function(){
  this.flakes = [];

  //Create starter flakes.
  for(var i = 0; i < this.settings.flakes; i++){
    this.flakes.push(new Flake(this.canvas.width, this.canvas.height));
  }

  //Apply multiple logic iterations to the starter flakes in order to fill the canvas.
  for(var i = 0; i < this.settings.prePhysics; i++){
    this.flakeLogic();
  }
};

CanvasSnow.prototype.flakeLogic = function(){
  //Move flakes.
  for(var i = 0; i < this.flakes.length; i++){
    this.flakes[i].x += this.flakes[i].speed;
    this.flakes[i].y += this.flakes[i].speed;
  }

  //Remove flakes that are no nonger visiable on the canvas.
  for(var i = 0; i < this.flakes.length; i++){
    if(this.flakes[i].x > this.canvas.width || this.flakes[i].y > this.canvas.height){
      this.flakes.splice(i, 1);
    }
  }

  //Create new snow flakes to fill in for the deleted ones.
  for(var i = 0; i < this.settings.flakes - this.flakes.length; i++){
    this.flakes.push(new Flake(this.canvas.width, this.canvas.height));
  }
};

CanvasSnow.prototype.render = function(){
  var flakeCount = this.flakes.length;

  this.canvas.width = this.canvas.width;

  if(this.settings.stats){
    this.context.fillStyle = '#ffffff';
    this.context.fillText('Snow flakes: ' + flakeCount, 10, 20);
    this.context.fillText('FPS: ' + this.framerate.fps, 10, 35);
  }

  while(flakeCount--){
    this.context.fillStyle = 'rgba(255, 255, 255, ' + this.flakes[flakeCount].opacity + ')';
    this.context.beginPath();
    this.context.arc(this.flakes[flakeCount].x, this.flakes[flakeCount].y, this.flakes[flakeCount].size, 0, Math.PI*2, true); 
    this.context.closePath();
    this.context.fill();
  }

  this.framerate.frames++;
};

function Flake(width, height){
  var canvas = $('<canvas></canvas>')[0]
  var context = canvas.getContext('2d');
  context.canvas.width = context.canvas.height = 20;

  //Determines if the flake will come from the top or left side.
  var s = Math.round(Math.random());

  //Positions the flake randomly.
  if(s){
    this.x = -10;
    this.y = Math.round(Math.random()*height);
  }else{
    this.x = Math.round(Math.random()*width);
    this.y = -10;
  }

  this.speed = (Math.random()*3)+1;
  this.opacity = Math.random();
  this.size = Math.random()+1;
}

function FrameRate(){
  this.fps = 0;
  this.frames = 0;
  setInterval(this.calculate, 1000, this);
}
FrameRate.prototype.calculate = function(This){
  This.fps = This.frames;
  This.frames = 0;
};

var snowingCanvas = $('#snowing-canvas');

var snow = new CanvasSnow(snowingCanvas[0], {
  flakes:300, //The amount of flakes to be displayed.
  stats:false, //Use false to hide the flake and fps counters.
  prePhysics:500 //This is the amount of times physics is applied to the snow before the animation starts.
  //For example, setting it to 0 would display no flakes on the screen, leaving it to slowely fill up.
});

//This part is only used if you want the canvas to resize to fill the window.
//Instead you can set a static size on the canvas element with the width and height attributes.
$(window).on('resize', function(){
  snowingCanvas.attr({'width':$(this).width(), 'height':$(this).height()});
  //New flakes are created after a canvas resize.
  //Not doing so would yield a undesired effect with the animation.
  snow.init();
}).trigger('resize');

//Begins the animation. 
(function animate(){
  requestAnimationFrame(animate);
  snow.render();
})();