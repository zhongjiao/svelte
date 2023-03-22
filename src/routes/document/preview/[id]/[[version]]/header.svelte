<script>
  export let name
  export let dateType
  export let updateTime
  export let effectTime

  const downLoad = (type) => {
      // const { pdfFile } = this.dataContent || {};
      // // 优先走后台下载
      // if (pdfFile) {
      //   if (utils.isIOS() || utils.isAndroidMini()) {
      //     window.localStorage.setItem("privacy_pdf_url", pdfFile);
      //     this.$router.push("/copy-tips");
      //   } else {
      //     window.open(pdfFile);
      //   }
      // } else {
      //   // 走前端下载
      //   const isPC = utils.isPC();
      //   if (!this.isCanDownload && !isPC) {
      //     const curHref = window.location.href;
      //     // 复制的是可下载的那个文档页面
      //     // 兼容拼写错误的问题
      //     if (curHref.indexOf("/preview/") !== -1) {
      //       const url = curHref.replace("/preview/", "/download/");
      //       window.localStorage.setItem("privacy_pdf_url", url); // 存本地
      //       this.$router.push("/copy-tips");
      //     } else {
      //       const url = curHref.replace("/priview/", "/download/");
      //       window.localStorage.setItem("privacy_pdf_url", url); // 存本地
      //       this.$router.push("/copy-tips");
      //     }
      //     return;
      //   }
      //   const typeKey = {
      //     web: "pc-document",
      //     app: "app-document",
      //   };
      //   const dom = document.getElementById(`${typeKey[type]}`);
      //   const options = {
      //     tainttest: true, //检测每张图片都已经加载完成
      //     useCORS: true,
      //     width: dom.scrollWidth, //dom 原始宽度
      //     height: dom.scrollHeight, //dom 原始高度
      //   };
      //   this.$store.dispatch("getLoading", true);
      //   generateResume(dom, options, `${this.dataContent.name}`);
      // }
    }
</script>

<div class="flex justify-between">
  <div class="title font-medium overflow-hidden whitespace-nowrap text-ellipsis">
    {name}
  </div>

  <div class="flex items-center font-semibold text-sm">
    {#if updateTime}      
      <span
        class="ml-auto"
        style:margin-right={ effectTime ? '0' : '2rem' }
      >
        {dateType || '更新日期'}：{ updateTime }
      </span>
    {/if}

    {#if effectTime}
      <span
        class="mr-2"
        style:margin-left={
          updateTime ? '2rem' : 'auto'
        }
      >
        生效日期：{ effectTime }
      </span>
    {/if}

    <span class="download-btn cursor-pointer mx-5 font-normal text-sm" on:click="{() => downLoad('web')}">
      <span class="iconfont privacy-xiazai"></span>
      下载
    </span>
  </div>
</div>

<style>
  .title {
    padding: 15px 0 15px 40px;
    font-size: 18px;

  }
  .download-btn {
    color: #1d51d9;
  }
</style>
