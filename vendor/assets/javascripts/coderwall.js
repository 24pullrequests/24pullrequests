
/*
  Author:                 Amsul
  Author URI:             http://amsul.ca
  Description:            Displays Coderwall badges for your team
  Version:                1.0
  Created on:             31/03/2012
  Last Updated:           10 April, 2012
*/

(function() {
  var CodersWall;

  window.$ = jQuery;

  // jquery.jsonp 1.0.4 (c) 2009 Julian Aubourg | MIT License
  // http://code.google.com/p/jquery-jsonp/
  (function(){function e(){}function v(F){d=[F]}function o(J,G,H,I){try{I=J&&J.apply(G.context||G,H)}catch(F){I=!1}return I}function n(F){return/\?/.test(F)?"&":"?"}var p="async",t="charset",r="",D="error",u="insertBefore",s="_jqjsp",A="on",h=A+"click",k=A+D,q=A+"load",y=A+"readystatechange",b="readyState",C="removeChild",j="<script>",z="success",B="timeout",f=window,a=$.Deferred,i=$("head")[0]||document.documentElement,c=i.firstChild,x={},m=0,d,l={callback:s,url:location.href},w=f.opera;function E(J){J=$.extend({},l,J);var H=J.success,O=J.error,G=J.complete,X=J.dataFilter,Z=J.callbackParameter,P=J.callback,Y=J.cache,F=J.pageCache,I=J.charset,K=J.url,ab=J.data,R=J.timeout,N,V=0,T=e,Q,M,aa,L,U;a&&a(function(ac){ac.done(H).fail(O);H=ac.resolve;O=ac.reject}).promise(J);J.abort=function(){!(V++)&&T()};if(o(J.beforeSend,J,[J])===!1||V){return J}K=K||r;ab=ab?((typeof ab)=="string"?ab:$.param(ab,J.traditional)):r;K+=ab?(n(K)+ab):r;Z&&(K+=n(K)+encodeURIComponent(Z)+"=?");!Y&&!F&&(K+=n(K)+"_"+(new Date()).getTime()+"=");K=K.replace(/=\?(&|$)/,"="+P+"$1");function W(ac){if(!(V++)){T();F&&(x[K]={s:[ac]});X&&(ac=X.apply(J,[ac]));o(H,J,[ac,z]);o(G,J,[J,z])}}function S(ac){if(!(V++)){T();F&&ac!=B&&(x[K]=ac);o(O,J,[J,ac]);o(G,J,[J,ac])}}if(F&&(N=x[K])){N.s?W(N.s[0]):S(N)}else{f[P]=v;aa=$(j)[0];aa.id=s+m++;if(I){aa[t]=I}w&&w.version()<11.6?((L=$(j)[0]).text="document.getElementById('"+aa.id+"')."+k+"()"):(aa[p]=p);if(y in aa){aa.htmlFor=aa.id;aa.event=h}aa[q]=aa[k]=aa[y]=function(ac){if(!aa[b]||!/i/.test(aa[b])){try{aa[h]&&aa[h]()}catch(ad){}ac=d;d=0;ac?W(ac[0]):S(D)}};aa.src=K;T=function(ac){U&&clearTimeout(U);aa[y]=aa[q]=aa[k]=null;i[C](aa);L&&i[C](L)};i[u](aa,c);L&&i[u](L,c);U=R>0&&setTimeout(function(){S(B)},R)}return J}E.setup=function(F){$.extend(l,F)};$.jsonp=E})();

  CodersWall = {
    init: function(options, coderBox) {
      var self;
      self = this;
      self.box = coderBox;
      self.$box = $(coderBox);
      self.teamBadges = {};
      self.options = $.extend({}, $.fn.codersWall.options, options);
      self.team = (typeof options !== 'undefined' ? options.team : self.options.team);
      self.compileBadges();
      return self;
    },
    compileBadges: function() {
      var badgeFetcher, coder, i, self, _len, _ref;
      self = this;
      self.teamFetcher = function(coder, count) {
        return $.jsonp({
          url: 'http://coderwall.com/' + coder + '.json?callback=?',
          cache: true,
          success: function(coder, resp) {
            return self.storeTeamBadges(coder, resp);
          },
          error: function(req, resp) {
            return self.storeTeamBadges(coder, resp);
          }
        });
      };
      self.teamFetcher.count = 0;
      self.teamFetcher.requests = [];
      badgeFetcher = function(coder, i) {
        return self.teamFetcher.requests[i] = self.teamFetcher(coder, self.teamFetcher.count);
      };
      _ref = self.team;
      for (i = 0, _len = _ref.length; i < _len; i++) {
        coder = _ref[i];
        badgeFetcher(coder, i);
      }
      return self;
    },
    storeTeamBadges: function(coder, response) {
      var badge, badgeName, self, _i, _len, _ref;
      self = this;
      if (response === 'success') {
        _ref = coder.data.badges;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          badge = _ref[_i];
          badgeName = badge.name;
          if (typeof self.teamBadges[badgeName] === 'undefined') {
            self.teamBadges[badgeName] = badge;
            self.teamBadges[badgeName].coders = [coder.data.username];
            self.teamBadges[badgeName].count = 1;
          } else {
            self.teamBadges[badgeName].coders.push(coder.data.username);
            self.teamBadges[badgeName].count += 1;
          }
        }
      }
      self.teamFetcher.count += 1;
      if (self.team.length === self.teamFetcher.count) {
        self.printBadges(self.teamBadges, self.team);
      }
      return self;
    },
    printBadges: function(teamBadges, team) {
      var badge, badgeSize, coder, compileCoderList, compileList, self, teamBadgesList, _i, _len;
      self = this;
      badgeSize = self.options.badge_size;
      compileList = function(badge, badgeObj) {
        return '<li class="box-badge"><div class="badge-icon' + (badgeObj.count > 1 ? ' show-count' : '') + '" data-count="' + badgeObj.count + '"><img width="' + badgeSize + '" height="' + badgeSize + '" alt="' + badge + '" title="' + badgeObj.description + '" src="' + badgeObj.badge + '"></div><div class="badge-name">' + badge + '</div></li>';
      };
      teamBadgesList = '<ul id="team_box">';
      for (badge in teamBadges) {
        teamBadgesList += compileList(badge, teamBadges[badge]);
      }
      teamBadgesList += '</ul>';
      compileCoderList = function(coder) {
        return '<a href="http://coderwall.com/' + coder + '" target="_blank">' + coder + '</a>';
      };
      teamBadgesList += '<div class="team-coders"><strong>Badges achieved by:&nbsp;</strong>';
      for (_i = 0, _len = team.length; _i < _len; _i++) {
        coder = team[_i];
        teamBadgesList += compileCoderList(coder);
      }
      teamBadgesList += '</div>';
      self.$box.html(teamBadgesList);
      return self;
    }
  };

  $.fn.codersWall = function(options) {
    return this.each(function() {
      var coderwall;
      coderwall = Object.create(CodersWall);
      coderwall.init(options, this);
      return this;
    });
  };

  $.fn.codersWall.options = {
    team: ['amsul', 'maxpresman'],
    badge_size: 72
  };

}).call(this);
