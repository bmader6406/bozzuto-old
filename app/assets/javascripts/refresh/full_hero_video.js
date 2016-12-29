//= require ../utils/add-youtube-api
//= require ../utils/debounce

(function($) {

  window.REFRESH = window.REFRESH || {};

  REFRESH.fullHeroVideo = function() {};

  REFRESH.fullHeroVideo.prototype = {
    player: null,
    playerDefaults: {
      autohide: 1,
      autoplay: 0,
      controls: 0,
      disablekb: 1,
      enablejsapi: 0,
      iv_load_policy: 3,
      loop: 1,
      modestbranding: 0,
      playlist: null,
      rel: 0,
      showinfo: 1
    },

    init: function(el) {
      this.cacheDOM(el)
    },

    cacheDOM: function(el) {
      this.$el                     = el;
      this.$wrapper                = this.$el.parents('.js-fullHeroVideoWrapper');
      this.$parentSection          = this.$el.parents('section');
      this.$elId                   = this.$el.attr('id');
      this.settings                = this.playerDefaults;
      this.playerDefaults.playlist = this.$elId;
      this.$pause                  = this.$parentSection.find('.js-pauseVideo');
      this.$play                   = this.$parentSection.find('.js-playVideo');
      this.player;
      this.playerOffset            = 200;

      this.listen();
    },

    listen: function() {
      $(document).on('youtubeAPIReady', this.createPlayer.bind(this));
      $(window).on('resize', debounce(this.vidRescale.bind(this), 200) );
      this.$pause.on('click', this.pauseVideo.bind(this))
      this.$play.on('click', this.playVideo.bind(this))
    },

    createPlayer: function() {
      this.player = new YT.Player(this.$elId, {
        videoId: this.$elId,
        events: {
          'onReady': this.onPlayerReady.bind(this)
        },
        playerVars: this.settings
      });
    },

    // this originally function comes from https://codepen.io/ccrch/pen/GgPLVW
    vidRescale: function(){
      var w = this.$parentSection.width() + (this.playerOffset*3);
      var h = this.$parentSection.innerHeight() + (this.playerOffset);

      var ratio = w * (9/16) - 100;

      if (h > ratio){
       return this.$wrapper.css({'transform': 'scale(' + (16/9) / (h/w) + ')'});

      } else {
        return this.$wrapper.css({'transform': 'scale(' + (9/16) / (h/w) + ')'});
      }
    },

    onPlayerReady: function() {
      this.vidRescale();
      this.player.mute();
      this.player.playVideo();
    },

    pauseVideo: function() {
      this.player.pauseVideo();
    },

    playVideo: function() {
      this.player.playVideo();
    }
  };

  $(document).ready(function() {
    addYoutubeScript();
    addYoutubeEvent();
    return $('.js-fullHeroVideo').each(function() {
      (new REFRESH.fullHeroVideo()).init($(this));
    });
  });

})(jQuery);