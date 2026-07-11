<section class="mbr-box mbr-section mbr-section--relative mbr-section--fixed-size mbr-section--full-height mbr-section--bg-adapted mbr-parallax-background" id="header4-7" style="background-image: url(<?php echo '//'.$_SERVER['HTTP_HOST'].'/'.$bing->bingImage();?>)">
	<div class="mbr-overlay" style="opacity: 0.2;"></div> 
	<div class="mbr-box__magnet mbr-box__magnet--sm-padding mbr-box__magnet--center-center mbr-after-navbar">
		<div class="mbr-box__container mbr-section__container container">
			<div class="mbr-box mbr-box--stretched">
				<div class="mbr-box__magnet mbr-box__magnet--center-center">
					<div class="row">
						<div class=" col-sm-8 col-sm-offset-2">
							<div class="mbr-hero animated fadeInUp">
								<input type="hidden" id="shhh" />
								<div id="datepicker"></div>
								<a href="#" id="fecha" class="mbr-buttons__link text-white">
								<h1><?php echo $votdTitle;?></h1>
								</a>
								<p class="mbr-hero__subtext">
								<?php echo $quote;?>
								</p>
								<h3><?php echo $verse;?><h3>
								<p><small><?php echo $bibleVersion;?></small></p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>