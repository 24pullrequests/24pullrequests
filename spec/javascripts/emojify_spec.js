//= require jquery
//= require emojione
//= require emoji

var smile = '<img class="emojione" alt="😄" src="//cdn.jsdelivr.net/emojione/assets/png/1F604.png?v=1.2.4">';

describe('Emojify', function(){
  it('simple', function(){
    var node = $('<p>:smile:</p>');
    Emojify.replace(node);
    expect(node.html()).to.eq('<span>' + smile + '</span>');
  });

  it('simple', function(){
    var node = $('<p>:smile:\n:smile:</p>');
    Emojify.replace(node);
    expect(node.html()).to.eq('<span>' + smile + '\n' + smile + '</span>');
  });

  it('simple with words', function(){
    var node = $('<p>foo :smile: foo</p>');
    Emojify.replace(node);
    expect(node.html()).to.eq('<span>foo ' + smile + ' foo</span>');
  });

  it('keep escaped html', function(){
    var node = $('<p>:smile: &lt;select&gt;</p>');
    Emojify.replace(node);
    expect(node.html()).to.eq('<span>' + smile + ' &lt;select&gt;</span>');
  });

  it('no emojies', function(){
    var node = $('<p>foo</p>');
    Emojify.replace(node);
    expect(node.html()).to.eq('foo');
  });

  it('Colons!', function(){
    var node = $('<p>Rack::Session::Cookie :sessions. Resolves: #2492</p>');
    Emojify.replace(node);
    expect(node.html()).to.eq('Rack::Session::Cookie :sessions. Resolves: #2492');
  });

  it('Double colons start and end', function(){
    var node = $('<p>::Session::</p>');
    Emojify.replace(node);
    expect(node.html()).to.eq('::Session::');
  });
});
