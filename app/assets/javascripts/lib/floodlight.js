var Floodlight = {

	init: function() {
                this.vars();
		this.binds();
	},

	vars: function() {
		this.$links = $('.fl-record-click');
	},

	binds: function() {
		this.$links.bind('click', this.recordButtonClick);
	},

	recordButtonClick: function(e) {
		var axel            = Math.random()+"";
		var a               = axel * 10000000000000000;
		var spotpix         = new Image();
		var $el             = $(this);
		var cat             = $el.attr('data-cat');
		var property_name   = $el.attr('data-prop');
		var property_string = (property_name.length > 0) ? ';u1=' + property_name : '';

		spotpix.src="//ad.doubleclick.net/activity;src=4076176;type=conve135;cat=" + cat + property_string + ";ord=" + a + "?";
	}

};
