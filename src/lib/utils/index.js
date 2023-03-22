// 获取随机字符串
export function randomString(len){
  len = len || 32;
  const $chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz123456789';
  const maxPos = $chars.length;
  let pwd = '';
  for (let i = 0; i < len; i++) {
    pwd += $chars.charAt(Math.floor(Math.random() * maxPos));
  }
  return pwd;
}

function twoDigits(val){
  if (val < 10) return `0${val}`;
   return val;
 }

// 获取当前时间
export function getDate() {
  const timezone = 8;
  const offsetGMT = new Date().getTimezoneOffset();
  const nowDate = new Date().getTime();
  const today = new Date(nowDate + (offsetGMT * 60 * 1000) + (timezone * 60 * 60 * 1000));
  const date = `${today.getFullYear()}-${twoDigits(today.getMonth() + 1)}-${twoDigits(today.getDate())}`;
  const time = `${twoDigits(today.getHours())}:${twoDigits(today.getMinutes())}:${twoDigits(today.getSeconds())}`;
  return `${date} ${time}`;
}
