import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

const curProject = 'document'
const curProjectApi = `${curProject}_ext_api`
const curProjectApiTarget = 'http://external.test.srv.document.woa.com' // 测试
const curProjectApiRewrite = {}

const initProxy = () => {
  const proxy = {}
  // 当前项目 api 转发
  proxy[`/${curProjectApi}`] = {
    target: curProjectApiTarget,
    pathRewrite: curProjectApiRewrite,
		rewrite: (path) => {
			const regExp = RegExp(`^\/${curProjectApi}`);
			const p = path.replace(regExp, '/api/v1');
			return p;
		},
    changeOrigin: true,
  }
  return proxy
}

const proxy = initProxy()

export default defineConfig({
	base: '/document/',
	server: {
		open: '/document',
		proxy,
	},
	plugins: [sveltekit()]
});
