// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import Swiper from 'swiper/swiper-bundle';
import 'swiper/swiper-bundle.css';
import "../script";

// ✅ Webpackに画像を認識させる（背景画像やimage_tag補完用）
const images = require.context('../images', true, /\.(png|jpe?g|svg)$/);
