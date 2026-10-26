    <noscript><div class="alert alert-danger">{LANG.nojs}</div></noscript>
    <div class="vmu-topbar">
        <div class="vmu-wrap">
            <ul class="vmu-contacts">
                <li><i class="fa fa-map-marker"></i> 484 Lạch Tray, P. Lê Chân, TP. Hải Phòng</li>
                <li><i class="fa fa-phone"></i> <a href="tel:+842253829109">(+84) 225 3829 109</a></li>
                <li class="hidden-xs"><i class="fa fa-envelope"></i> <a href="mailto:info@vimaru.edu.vn">info@vimaru.edu.vn</a></li>
            </ul>
            <ul class="vmu-toplinks">
                <li class="hidden-xs"><a href="https://eoffice.vimaru.edu.vn" target="_blank" rel="noopener">E-Office</a></li>
                <li class="hidden-xs"><a href="https://lib.vimaru.edu.vn/" target="_blank" rel="noopener">Thư viện</a></li>
                <li><a href="https://www.facebook.com/daihochanghaivietnam" target="_blank" rel="noopener" aria-label="Facebook"><i class="fa fa-facebook"></i></a></li>
                <li class="vmu-lang"><b>VI</b> <a href="https://eng.vimaru.edu.vn/" target="_blank" rel="noopener">EN</a></li>
            </ul>
        </div>
    </div>
    <header class="vmu-header">
        <div class="vmu-wrap vmu-header-inner">
            <a class="vmu-logo" href="{THEME_SITE_HREF}" title="{SITE_NAME}">
                <img src="{NV_BASE_SITEURL}uploads/news/vimaru/site/logo-truong-96.png" alt="Logo Trường Đại học Hàng hải Việt Nam" width="72" height="72">
                <span class="vmu-logo-text">
                    <small>Bộ Xây dựng</small>
                    <strong>Trường Đại học Hàng hải Việt Nam</strong>
                    <em>Vietnam Maritime University</em>
                </span>
            </a>
            <!-- BEGIN: site_name_h1 --><h1 class="sr-only">{SITE_NAME}</h1><!-- END: site_name_h1 -->
            <!-- BEGIN: site_name_span --><span class="sr-only">{SITE_NAME}</span><!-- END: site_name_span -->
            <div class="vmu-search headerSearch">
                <div class="input-group">
                    <input type="text" class="form-control" maxlength="{NV_MAX_SEARCH_LENGTH}" placeholder="Tìm kiếm thông tin...">
                    <span class="input-group-btn"><button type="button" class="btn" data-url="{THEME_SEARCH_URL}" data-minlength="{NV_MIN_SEARCH_LENGTH}" data-click="y" aria-label="Tìm kiếm"><em class="fa fa-search"></em></button></span>
                </div>
            </div>
            <button type="button" class="vmu-burger" aria-label="Menu" onclick="document.body.classList.toggle('vmu-menu-open')"><span></span><span></span><span></span></button>
        </div>
        <nav class="vmu-nav" id="menusite">
            <div class="vmu-wrap">
                <ul class="vmu-menu">
                    <li class="home"><a href="{THEME_SITE_HREF}" aria-label="Trang chủ"><i class="fa fa-home"></i></a></li>
                    <!-- BEGIN: vmenu -->
                    <li class="{VMENU.cls}">
                        <a href="{VMENU.link}"{VMENU.target}>{VMENU.title}{VMENU.caret}</a>
                        <!-- BEGIN: sub --><ul class="vmu-drop"><!-- BEGIN: item --><li><a href="{VSUB.link}"{VSUB.target}>{VSUB.title}</a></li><!-- END: item --></ul><!-- END: sub -->
                    </li>
                    <!-- END: vmenu -->
                </ul>
                <div class="personalArea hidden">[PERSONALAREA]</div>
            </div>
        </nav>
    </header>
    <!-- BEGIN: home -->
    <section class="vmu-hero" id="vmuHero">
        <div class="vmu-slides">
            <a class="vmu-slide active" href="{THEME_SITE_HREF}&amp;nv=news"><img src="{NV_BASE_SITEURL}uploads/news/vimaru/site/banner-0.png" alt="Giải thưởng Cơ sở đào tạo hàng hải xuất sắc nhất tại AMET Global Maritime Awards 2026"></a>
            <a class="vmu-slide" href="{THEME_SITE_HREF}&amp;nv=news"><img src="{NV_BASE_SITEURL}uploads/news/vimaru/site/banner-1.jpg" alt="Trường Đại học Hàng hải Việt Nam vinh dự đón nhận Cờ thi đua của Bộ Xây dựng" loading="lazy"></a>
            <a class="vmu-slide" href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Sinh-vien"><img src="{NV_BASE_SITEURL}uploads/news/vimaru/site/banner-2.jpg" alt="02 Quán quân của Trường Đại học Hàng hải Việt Nam tại MOS World Championship 2026" loading="lazy"></a>
            <a class="vmu-slide" href="https://vimaru.edu.vn/tin-tuc/sinh-vien-truong-dai-hoc-hang-hai-viet-nam-xuat-sac-gianh-huy-chuong-vang-gioi-noi-dung" target="_blank" rel="noopener"><img src="{NV_BASE_SITEURL}uploads/news/vimaru/site/banner-3.png" alt="Sinh viên Nguyễn Mai Chi giành Huy chương Vàng thế giới tại MOS World Championship 2026" loading="lazy"></a>
            <a class="vmu-slide" href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Hop-tac-quoc-te/trao-van-kien-hop-tac-giua-truong-dai-hoc-hang-hai-viet-nam-va-truong-dai-hoc-hang-hai-quoc-9"><img src="{NV_BASE_SITEURL}uploads/news/vimaru/site/banner-4.png" alt="Biên bản ghi nhớ hợp tác giữa Trường Đại học Hàng hải Việt Nam và Trường Đại học Hàng hải Quốc tế Panama" loading="lazy"></a>
            <a class="vmu-slide" href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Hop-tac-quoc-te/hieu-truong-truong-dai-hoc-hang-hai-viet-nam-tham-du-hoi-nghi-tong-thuong-nien-lan-thu-26-8"><img src="{NV_BASE_SITEURL}uploads/news/vimaru/site/banner-5.jpg" alt="Hiệu trưởng tham dự Hội nghị tổng thể thường niên lần thứ 26 của IAMU tại Croatia" loading="lazy"></a>
        </div>
        <button class="vmu-hero-nav prev" type="button" aria-label="Trước"><i class="fa fa-angle-left"></i></button>
        <button class="vmu-hero-nav next" type="button" aria-label="Sau"><i class="fa fa-angle-right"></i></button>
        <div class="vmu-dots"></div>
    </section>
    <section class="vmu-quick">
        <div class="vmu-wrap">
            <a href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Tuyen-sinh"><i class="fa fa-graduation-cap"></i><b>Tuyển sinh</b><span>Đại học, sau đại học</span></a>
            <a href="https://daotao.vimaru.edu.vn" target="_blank" rel="noopener"><i class="fa fa-book"></i><b>Đào tạo</b><span>Phòng Đào tạo</span></a>
            <a href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Khoa-hoc-cong-nghe"><i class="fa fa-flask"></i><b>Khoa học công nghệ</b><span>Nghiên cứu, hội thảo</span></a>
            <a href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Hop-tac-quoc-te"><i class="fa fa-globe"></i><b>Hợp tác quốc tế</b><span>Đối tác toàn cầu</span></a>
            <a href="https://ctsv.vimaru.edu.vn" target="_blank" rel="noopener"><i class="fa fa-users"></i><b>Sinh viên</b><span>Công tác sinh viên</span></a>
        </div>
    </section>
    <section class="vmu-section">
        <div class="vmu-wrap vmu-main-grid">
            <div>
                <div class="vmu-head"><h3><span>Tin tức</span> - Sự kiện</h3><a href="{THEME_SITE_HREF}&amp;nv=news">Xem tất cả <i class="fa fa-angle-right"></i></a></div>
                <div class="vmu-news">
                    <!-- BEGIN: featured -->
                    <a class="vmu-feat" href="{NEWS.link}"><div class="img"><img src="{NEWS.img}" alt="{NEWS.title}"></div><div class="body"><span class="cat">{NEWS.cat}</span><h4>{NEWS.title}</h4><p>{NEWS.hometext}</p><time><i class="fa fa-calendar"></i> {NEWS.date}</time></div></a>
                    <!-- END: featured -->
                    <div class="vmu-news-grid">
                        <!-- BEGIN: news -->
                        <a class="vmu-card" href="{NEWS.link}"><div class="img"><img src="{NEWS.img}" alt="{NEWS.title}" loading="lazy"></div><div class="body"><span class="cat">{NEWS.cat}</span><h5>{NEWS.title}</h5><time><i class="fa fa-calendar"></i> {NEWS.date}</time></div></a>
                        <!-- END: news -->
                    </div>
                </div>
            </div>
            <aside>
                <div class="vmu-box">
                    <div class="vmu-head"><h3><span>Thông báo</span></h3><a href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Thong-bao">Xem thêm <i class="fa fa-angle-right"></i></a></div>
                    <ul class="vmu-notice">
                        <!-- BEGIN: notice --><li><div class="d"><b>{NT.day}</b><span>{NT.month}/{NT.year}</span></div><a href="{NT.link}">{NT.title}</a></li><!-- END: notice -->
                    </ul>
                </div>
            </aside>
        </div>
    </section>
    <section class="vmu-stats">
        <div class="vmu-wrap">
            <div><b>1956</b><span>Năm thành lập</span></div>
            <div><b>70</b><span>Năm xây dựng &amp; phát triển</span></div>
            <div><b>11</b><span>Khoa chuyên môn</span></div>
            <div><b>30+</b><span>Phòng thí nghiệm, thực hành mô phỏng</span></div>
        </div>
    </section>
    <section class="vmu-section alt">
        <div class="vmu-wrap vmu-two">
            <div>
                <div class="vmu-head"><h3><span>Hội nghị</span> - Hội thảo</h3><a href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Hoi-nghi-Hoi-thao">Xem thêm <i class="fa fa-angle-right"></i></a></div>
                <!-- BEGIN: event -->
                <a class="vmu-event" href="{EV.link}"><div class="d"><b>{EV.day}</b><span>Th{EV.month}/{EV.year}</span></div><div><h5>{EV.title}</h5><p>{EV.hometext}</p></div></a>
                <!-- END: event -->
            </div>
            <div class="vmu-ts">
                <div class="vmu-head"><h3><span>Tuyển sinh</span></h3><a href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Tuyen-sinh">Xem thêm <i class="fa fa-angle-right"></i></a></div>
                <div class="vmu-ts-box">
                    <ul>
                        <!-- BEGIN: ts --><li><a href="{TS.link}"><i class="fa fa-file-text-o"></i> {TS.title}</a><time>{TS.date}</time></li><!-- END: ts -->
                    </ul>
                    <div class="vmu-ts-cta">
                        <a class="btn-vmu" href="http://tuyensinh.vimaru.edu.vn" target="_blank" rel="noopener">Cổng tuyển sinh đại học <i class="fa fa-external-link"></i></a>
                        <a class="btn-vmu ghost" href="https://sdh.vimaru.edu.vn/tuyen-sinh" target="_blank" rel="noopener">Tuyển sinh sau đại học</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section class="vmu-section">
        <div class="vmu-wrap">
            <div class="vmu-head"><h3><span>Khoa học công nghệ</span> &amp; Hợp tác quốc tế</h3><a href="{THEME_SITE_HREF}&amp;nv=news&amp;op=Khoa-hoc-cong-nghe">Xem thêm <i class="fa fa-angle-right"></i></a></div>
            <div class="vmu-kh">
                <!-- BEGIN: kh -->
                <a class="vmu-card" href="{KH.link}"><div class="img"><img src="{KH.img}" alt="{KH.title}" loading="lazy"></div><div class="body"><span class="cat">{KH.cat}</span><h5>{KH.title}</h5><time><i class="fa fa-calendar"></i> {KH.date}</time></div></a>
                <!-- END: kh -->
            </div>
        </div>
    </section>
    <section class="vmu-section units">
        <div class="vmu-wrap">
            <div class="vmu-head light"><h3><span>Khoa</span> - Viện đào tạo</h3></div>
            <div class="vmu-units">
                <a href="http://nav.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-ship"></i>Khoa Hàng hải</a>
                <a href="http://mtb.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-cogs"></i>Khoa Máy tàu biển</a>
                <a href="http://kt.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-line-chart"></i>Khoa Kinh tế</a>
                <a href="http://qttc.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-briefcase"></i>Khoa Quản trị - Tài chính</a>
                <a href="https://ee.vimaru.edu.vn" target="_blank" rel="noopener"><i class="fa fa-bolt"></i>Khoa Điện - Điện tử</a>
                <a href="http://kdt.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-anchor"></i>Khoa Đóng tàu</a>
                <a href="http://ctt.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-building"></i>Khoa Công trình</a>
                <a href="http://fit.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-laptop"></i>Khoa Công nghệ thông tin</a>
                <a href="http://kllct.vimaru.edu.vn/index.php/vi/" target="_blank" rel="noopener"><i class="fa fa-book"></i>Khoa Lý luận chính trị</a>
                <a href="http://ngoaingu.vimaru.edu.vn/?lang=vi" target="_blank" rel="noopener"><i class="fa fa-language"></i>Khoa Ngoại ngữ</a>
                <a href="http://cscb.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-calculator"></i>Khoa Cơ sở - Cơ bản</a>
                <a href="http://ise-vmu.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-globe"></i>Viện Đào tạo Quốc tế</a>
                <a href="http://sdh.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-graduation-cap"></i>Viện Đào tạo Sau đại học</a>
                <a href="http://see.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-star"></i>Viện Đào tạo Chất lượng cao</a>
                <a href="http://sme.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-wrench"></i>Viện Cơ khí</a>
                <a href="http://vienmoitruong.vimaru.edu.vn/" target="_blank" rel="noopener"><i class="fa fa-leaf"></i>Viện Môi trường</a>
            </div>
        </div>
    </section>
    <section class="vmu-section vmu-partners-sec">
        <div class="vmu-wrap">
            <div class="vmu-head"><h3><span>Đối tác</span></h3></div>
            <div class="vmu-partners">
                <div class="track">
                    <a href="https://www.bimco.org/" target="_blank" rel="noopener">BIMCO</a><a href="http://wmu.se/" target="_blank" rel="noopener">World Maritime University</a><a href="http://www.kaiyodai.ac.jp/english-c/" target="_blank" rel="noopener">Tokyo University of Marine Science and Technology</a><a href="http://en.shmtu.edu.cn/" target="_blank" rel="noopener">Shanghai Maritime University</a><a href="http://www.dlmu.edu.cn/" target="_blank" rel="noopener">Dalian Maritime University</a><a href="http://english.kmou.ac.kr/" target="_blank" rel="noopener">Korea Maritime and Ocean University</a><a href="http://www.mmu.ac.kr/" target="_blank" rel="noopener">Mokpo National Maritime University</a><a href="http://www.kobe-u.ac.jp/en/" target="_blank" rel="noopener">Kobe University</a><a href="http://www.kyoto-u.ac.jp/en" target="_blank" rel="noopener">Kyoto University</a><a href="http://www.nippon-foundation.or.jp/en/" target="_blank" rel="noopener">The Nippon Foundation</a><a href="http://www.csum.edu" target="_blank" rel="noopener">California Maritime Academy</a><a href="https://www.amc.edu.au/" target="_blank" rel="noopener">Australian Maritime College</a><a href="http://www.ulg.ac.be/" target="_blank" rel="noopener">Université de Liège</a><a href="http://www.tjut.edu.cn/" target="_blank" rel="noopener">Tianjin University of Technology</a><a href="http://international.twu.edu.tw/" target="_blank" rel="noopener">TransWorld University</a><a href="http://www.isu.edu.tw/en1/" target="_blank" rel="noopener">I-Shou University</a><a href="http://www.vietnam.campusfrance.org/" target="_blank" rel="noopener">Campus France Vietnam</a><a href="https://wanasea.eu/" target="_blank" rel="noopener">Wanasea</a>
                </div>
            </div>
        </div>
    </section>
    <style>.section-body{display:none}</style>
    <!-- END: home -->
    <div class="section-body">
        <div class="vmu-wrap">
            <section>
                <div class="container" id="body">
                    <!-- BEGIN: breadcrumbs -->
                    <nav class="third-nav"><div class="breadcrumbs-wrap">
                        <div class="display">
                            <a class="show-subs-breadcrumbs hidden" href="#" onclick="showSubBreadcrumbs(this, event);"><em class="fa fa-lg fa-angle-right"></em></a>
                            <ul class="breadcrumbs list-none"></ul>
                        </div>
                        <ul class="subs-breadcrumbs"></ul>
                        <ul class="temp-breadcrumbs hidden" itemscope itemtype="https://schema.org/BreadcrumbList">
                            <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem"><a href="{THEME_SITE_HREF}" itemprop="item" title="{LANG.Home}"><span itemprop="name">{LANG.Home}</span></a><i class="hidden" itemprop="position" content="1"></i></li>
                            <!-- BEGIN: loop --><li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem"><a href="{BREADCRUMBS.link}" itemprop="item" title="{BREADCRUMBS.title}"><span class="txt" itemprop="name">{BREADCRUMBS.title}</span></a><i class="hidden" itemprop="position" content="{BREADCRUMBS.position}"></i></li><!-- END: loop -->
                        </ul>
                    </div></nav>
                    <!-- END: breadcrumbs -->
                    [THEME_ERROR_INFO]
