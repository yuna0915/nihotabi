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

// Webpackに画像を認識させる
const images = require.context('../images', true, /\.(png|jpe?g|svg)$/);

// ▼ トップページの背景画像切り替え処理
document.addEventListener('turbolinks:load', () => {
  const el = document.querySelector('.homes-top');
  if (!el) return;

  const bgImages = [
    images('./top1.jpg'),
    images('./top2.jpg'),
    images('./top3.jpg'),
    images('./top4.jpg')
  ];

  let i = 0;
  el.style.backgroundImage = `url(${bgImages[i]})`;

  setInterval(() => {
    i = (i + 1) % bgImages.length;
    el.style.backgroundImage = `url(${bgImages[i]})`;
  }, 5000);
});
