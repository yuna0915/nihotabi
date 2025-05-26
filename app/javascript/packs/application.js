// RailsアプリのJavaScript読み込み開始地点

import Rails from "@rails/ujs";                        // RailsのJavaScript機能を有効化
import Turbolinks from "turbolinks";                   // ページ遷移を高速化する機能
import * as ActiveStorage from "@rails/activestorage"; // ファイルアップロード機能
import "channels";                                     // Action Cable（リアルタイム通信）

import "jquery";                          // jQueryライブラリ
import "popper.js";                       // Bootstrapのツールチップ等の位置調整用
import "bootstrap";                       // BootstrapのJavaScript部分
import "../stylesheets/application";      // CSSスタイル読み込み

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import Swiper from 'swiper/swiper-bundle';     // スライダー表示ライブラリ
import 'swiper/swiper-bundle.css';             // スライダーのCSS
import "../script";                            // 独自JavaScriptコード
import "./image_upload_preview";               // 画像アップロードプレビュー処理
import "./address_autocomplete";               // 住所自動補完処理

// 画像をWebpackに認識させる設定
const images = require.context('../images', true, /\.(png|jpe?g|svg)$/);

// ページ読み込み完了時に実行する処理
document.addEventListener('turbolinks:load', () => {

  // トップページの背景画像を一定間隔で切替処理
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

    // 5秒ごとに背景画像切替
    setInterval(() => {
      i = (i + 1) % bgImages.length;
      el.style.backgroundImage = `url(${bgImages[i]})`;
    }, 5000);
  }

  // 通常ページの背景画像設定
  const body = document.querySelector('body');
  if (body && body.classList.contains('main-background')) {
    const mainImage = images('./main.jpg');

    // 背景に白の薄いグラデーションを重ねて、文字などを見やすくする
    body.style.backgroundImage = `linear-gradient(rgba(255,255,255,0.8), rgba(255,255,255,0.8)), url(${mainImage})`;
    body.style.backgroundSize = 'cover';           // 背景画像を画面に合わせて拡大縮小
    body.style.backgroundRepeat = 'no-repeat';     // 背景画像の繰り返しをしない
    body.style.backgroundAttachment = 'fixed';     // スクロールしても背景を固定
    body.style.backgroundPosition = 'center';      // 背景画像の位置を中央に設定
  }

  // 管理者トップページ用背景設定
  const adminTop = document.querySelector('body.admin-homes-top');
  if (adminTop) {
    const mainImage = images('./main.jpg');
    adminTop.style.backgroundImage = `linear-gradient(rgba(255,255,255,0.75), rgba(255,255,255,0.75)), url(${mainImage})`;
    adminTop.style.backgroundSize = 'cover';
    adminTop.style.backgroundRepeat = 'no-repeat';
    adminTop.style.backgroundAttachment = 'fixed';
    adminTop.style.backgroundPosition = 'center';
  }

  // Aboutページにある画像スライダーを初期化し動かす処理
  const aboutSwiper = document.querySelector('.about-swiper .swiper');
  if (aboutSwiper) {
    new Swiper(aboutSwiper, {
      loop: true,                 // ループ再生
      speed: 800,                 // スライド切替の速さ
      autoplay: {
        delay: 5000,              // 5秒ごとに自動切替
        disableOnInteraction: false,  // ユーザー操作後も自動再生を続ける
      },
      pagination: {
        el: '.swiper-pagination',  // ページネーションの表示場所
        clickable: true            // ページネーションをクリック可能に
      },
      navigation: {
        nextEl: '.swiper-button-next',  // 次へボタン
        prevEl: '.swiper-button-prev'   // 前へボタン
      }
    });
  }
});
