/* VIMARU theme */
$(function () {
    var $h = $('#vmuHero');
    if ($h.length) {
        var $s = $h.find('.vmu-slide'), $d = $h.find('.vmu-dots'), i = 0, t;
        $s.each(function (k) { $d.append('<i' + (k ? '' : ' class="on"') + '></i>'); });
        var go = function (n) {
            i = (n + $s.length) % $s.length;
            $s.removeClass('active').eq(i).addClass('active');
            $d.find('i').removeClass('on').eq(i).addClass('on');
        };
        var auto = function () { clearInterval(t); t = setInterval(function () { go(i + 1); }, 5500); };
        $h.find('.next').on('click', function () { go(i + 1); auto(); });
        $h.find('.prev').on('click', function () { go(i - 1); auto(); });
        $d.on('click', 'i', function () { go($(this).index()); auto(); });
        auto();
    }
    // duplicate partners for seamless marquee
    var $tr = $('.vmu-partners .track');
    if ($tr.length) { $tr.append($tr.html()); }
    // mobile submenu toggle
    $('.vmu-menu > li.has-sub > a').on('click', function (e) {
        if (window.innerWidth < 992) { e.preventDefault(); $(this).next('.vmu-drop').slideToggle(150); }
    });
});
