import md5 from 'js-md5';
import { randomString, getDate } from "$lib/utils";

export const ssr = false;

export async function load({ fetch, params }) {

  const getToken = async (action) => {

    const nonce = randomString(10);
    const timeStamp = getDate();
    const key = md5(nonce);
    const appid = "PrivacyDocument";
    const token = sessionStorage.getItem("token");

    if (token !== null && action !== "reFetchToken") {
      return token;
    } else {
      sessionStorage.removeItem("token");

      try {
        const res = await fetch(
          "/document_ext_api/authentication",
        {
          method: "post",
          body: '{}',
          headers: {
            accept: 'application/json, text/plain, */*',
            nonce,
            dtstamp: timeStamp,
            appid,
            sign: md5(appid + key + timeStamp + nonce),
          },
        });

        let token = ''
        if (res.ok) {
          token = await res.text();
          sessionStorage.setItem("token", token);
        }
        return token;
      } catch (error) {
        console.log('error: ', error)
        return ''
      }
    }
  }

  const getData = async () => {
    const id = params.id;
    const version = params.version;
    const url = "/document_ext_api/product-doc/detail";
    const documentData = {
      data: {},
      isAuth: true
    }

    const api = `${url}?${id ? `id=${id}` : ""}${
      version ? `&version=${version}` : ""
    }`;

    try {
      const token = await getToken()
      const res = await fetch(api, {
        headers: { token },
      });

      if (res.ok) {
        const data = await res.json();

        if ([20001, 20002, 20003].includes(data.code)) {
          await getToken("reFetchToken");
          await getData();
        } else {
          documentData.data = data.data;
        }
    
        if ([40000, 30000].includes(data.code)) {
          documentData.isAuth = false
        }
      }
      
      return documentData;
    } catch (error) {
      console.log('error: ', error)
      return documentData;
    }
  }

  return {
    id: params.id,
    data: await getData()
  }
}
