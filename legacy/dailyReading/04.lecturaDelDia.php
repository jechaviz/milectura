<section class="mbr-section mbr-section--relative mbr-section--fixed-size" id="content5-2" style="background-image: url(<?php echo '//'.$_SERVER['HTTP_HOST'].'/'.$bing->bingImage();?>);">
    <div class="mbr-overlay" style="opacity: 0.7; background-color: rgb(40, 50, 78);"></div>
	<div class="mbr-section__container container mbr-section__container--first" style="padding-top: 93px;">
		<div class="mbr-header mbr-header--wysiwyg row">
			<div class="col-sm-8 col-sm-offset-2">
				<h3 class="mbr-header__text"><?php echo $lddTitle;?></h3>
			</div>
		</div>
	</div>
	<div class="mbr-section__container container mbr-section__container--last" style="padding-bottom: 93px;">
		<div class="row">
			<div class="mbr-article mbr-article--wysiwyg col-sm-8 col-sm-offset-2">
				<!--ldd begin-->
				<div class="hidden" id="font-size"></div>
				<div class="row mbr-buttons--right">
					<button type="button" id="up" class="btn btn-default btn-circle"><i class="glyphicon glyphicon-plus"></i></button>
					<button type="button" id="dn" class="btn btn-primary btn-circle"><i class="glyphicon glyphicon-minus"></i></button>
				</div>
				<div id="ldd">
					<?php echo ($readingTitle.'<br/><div id="nt">'.
								$ntReadingText.
								'</div><!--.nt--><hr style="border-style: solid; border-color:#ccc; border-width:1.5px;"><div id="ot">'.
								$atReadingText.
								'</div><!--.at-->');
					?>
				</div>
				<!--ldd end-->
			</div>
		</div>
	</div>
</section>