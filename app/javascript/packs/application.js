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
import "./image_upload_preview";

// Webpackに画像を認識させる
const images = require.context('../images', true, /\.(png|jpe?g|svg)$/);

document.addEventListener('turbolinks:load', () => {
  // ▼ ユーザー側トップページの背景画像切り替え
  const el = document.querySelector('.homes-top');
  if (el) {
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
  }

  // ▼ 通常ページ用背景（main.jpg）
  const body = document.querySelector('body');
  if (body && body.classList.contains('main-background')) {
    const mainImage = images('./main.jpg');
    body.style.backgroundImage = `linear-gradient(rgba(255,255,255,0.8), rgba(255,255,255,0.8)), url(${mainImage})`;
    body.style.backgroundSize = 'cover';
    body.style.backgroundRepeat = 'no-repeat';
    body.style.backgroundAttachment = 'fixed';
    body.style.backgroundPosition = 'center';
  }

  // ▼ 管理者トップページ用背景（admin-homes-top）
  const adminTop = document.querySelector('body.admin-homes-top');
  if (adminTop) {
    const mainImage = images('./main.jpg');
    adminTop.style.backgroundImage = `linear-gradient(rgba(255,255,255,0.75), rgba(255,255,255,0.75)), url(${mainImage})`;
    adminTop.style.backgroundSize = 'cover';
    adminTop.style.backgroundRepeat = 'no-repeat';
    adminTop.style.backgroundAttachment = 'fixed';
    adminTop.style.backgroundPosition = 'center';
  }

  // ▼ アバウトページのスライダー初期化（←ここが今回の追記部分）
  const aboutSwiper = document.querySelector('.about-swiper .swiper');
  if (aboutSwiper) {
    new Swiper(aboutSwiper, {
      loop: true,
      speed: 800,
      autoplay: {
        delay: 5000,
        disableOnInteraction: false,
      },
      pagination: {
        el: '.swiper-pagination',
        clickable: true
      },
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev'
      }
    });
  }
});
