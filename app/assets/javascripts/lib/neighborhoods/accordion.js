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

    $('.accordion').each(function(){
 
       var LiN = $(this).find('.tab-section').length;

       if( LiN > 3){    
           $('.tab-section', this).eq(2).nextAll().hide().addClass('toggleable');
           $(this).append('<div class="more">Show More</div>');    
       }  
    });

    $('.accordion').on('click','.more', function(){
     
      if( $(this).hasClass('less') ){    
        $(this).text('Show More').removeClass('less');    
      }else{
        $(this).text('Show Less').addClass('less'); 
      }

      $(this).siblings('.tab-section.toggleable').slideToggle();
    }); 
});