import React from 'react';
import './footer.css'

function Footer() {
  return (
    <span id="footer">
		<div class="footerWrapper">
			<div class="row text-center text-xs-center text-sm-center text-md-center">
				<div class="col-xs-12 col-sm-6 col-md-6">
					<h5>Categories</h5>
					<ul class="list-unstyled quick-links">
<<<<<<< HEAD
						<li><a href=""><i class="fa fa-angle-double-right"></i>Books</a></li>
						<li><a href=""><i class="fa fa-angle-double-right"></i>Petshop</a></li>
						<li><a href=""><i class="fa fa-angle-double-right"></i>Clothing</a></li>
						<li><a href=""><i class="fa fa-angle-double-right"></i>Health</a></li>
						<li><a href=""><i class="fa fa-angle-double-right"></i>Home</a></li>
						<li><a href=""><i class="fa fa-angle-double-right"></i>Electronics</a></li>
						<li><a href=""><i class="fa fa-angle-double-right"></i>Consumables</a></li>
=======
						<li><a href="/electronics"><i class="fa fa-angle-double-right"></i>Electronics</a></li>
						<li><a href="/house"><i class="fa fa-angle-double-right"></i>House</a></li>
						<li><a href="/kitchen"><i class="fa fa-angle-double-right"></i>Kitchen</a></li>
						<li><a href="/sport"><i class="fa fa-angle-double-right"></i>Sport</a></li>
						<li><a href="/food"><i class="fa fa-angle-double-right"></i>Food</a></li>
						<li><a href="/laundry"><i class="fa fa-angle-double-right"></i>Laundry</a></li>
						<li><a href="/garden"><i class="fa fa-angle-double-right"></i>Garden</a></li>
						<li><a href="/fitness"><i class="fa fa-angle-double-right"></i>Fitness</a></li>
						<li><a href="/books"><i class="fa fa-angle-double-right"></i>Books</a></li>
						<li><a href="/cosmetics"><i class="fa fa-angle-double-right"></i>Cosmetics</a></li>
						<li><a href="/fashion"><i class="fa fa-angle-double-right"></i>Fashion</a></li>
>>>>>>> 51c84b30276c1580c51d299404e036b2073549cc
					</ul>
				</div>
				<div class="col-xs-12 col-sm-6 col-md-6">
					<h5>Quick links</h5>
					<ul class="list-unstyled quick-links">
						<li><a href="/"><i class="fa fa-angle-double-right"></i>Home</a></li>
						<li><a href="/aboutUs"><i class="fa fa-angle-double-right"></i>About Us</a></li>
						<li><a href="/faq"><i class="fa fa-angle-double-right"></i>FAQ</a></li>
						<li><a href="/career"><i class="fa fa-angle-double-right"></i>Career</a></li>
						<li><a href="/sitemap"><i class="fa fa-angle-double-right"></i>Sitemap</a></li>
					</ul>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12 col-sm-12 col-md-12 mt-2 mt-sm-5">
					<ul class="list-unstyled list-inline social text-center">
						<li class="list-inline-item"><a href="https://www.facebook.com/bazaar-tr"><i class="fa fa-facebook"></i></a></li>
						<li class="list-inline-item"><a href="https://www.twitter.com/bazaar-tr"><i class="fa fa-twitter"></i></a></li>
						<li class="list-inline-item"><a href="https://www.instagram.com/bazaar-tr"><i class="fa fa-instagram"></i></a></li>
						<li class="list-inline-item"><a href="mailto:info@bazaar.com.tr" target="_blank"><i class="fa fa-envelope"></i></a></li>
					</ul>
				</div>
				<hr/>
			</div>	
			<div class="row">
				<div class="col-xs-12 col-sm-12 col-md-12 mt-2 mt-sm-2 text-center text-black">
					<p>34342, Bebek, Besiktas, Istanbul/Turkey<br/>
					© {new Date().getFullYear()} <a href="/">Bazaar Inc.</a> All rights reserved</p>
				</div>
				<hr/>
			</div>	
		</div>
	</span>
  );
}

export default Footer;