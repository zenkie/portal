$(function () {
    // 广告条滑动相关JS
    var elem = document.getElementById('mySwipe');
    var bullets = document.getElementById('position').getElementsByTagName('li');
    window.mySwipe = Swipe(elem, {
        startSlide: 0,
        auto: 3000,
        continuous: true,
        // disableScroll: true,
        // stopPropagation: true,
        callback: function (pos) {
            var i = bullets.length;
            if (pos >= i) pos = pos - i;

            while (i--) {
                bullets[i].className = ' ';
            }
            bullets[pos].className = 'on';
        }
        // transitionEnd: function(index, element) {}
    });

});
