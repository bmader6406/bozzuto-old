$(document).ready(function () {
	$('.accordion .tab-content').slideUp();
    $('.accordion .accordian-heading').click(function(){
    	if($(this).closest('.tab-section').hasClass('active')) {
            $('.accordion .tab-content').slideUp();
            $('.accordion .tab-section').removeClass('active');
    	} else {
    		$('.accordion .tab-content').slideUp();
	    	$(this).next('.tab-content').slideDown();
    		$('.accordion .tab-section').removeClass('active');
	    	$(this).closest('.tab-section').addClass('active');
    	}
    });
});