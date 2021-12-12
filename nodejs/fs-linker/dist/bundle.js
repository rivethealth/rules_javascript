"use strict";var t=require("fs"),e=require("url"),n=require("path");function r(t){
return t&&"object"==typeof t&&"default"in t?t:{default:t}}var i=r(t),o=r(e),s=r(n);function a(t){
return t&&t.__esModule&&Object.prototype.hasOwnProperty.call(t,"default")?t.default:t}function c(t,e,n){return t(n={
path:e,exports:{},require:function(t,e){return function(){
throw new Error("Dynamic requires are not currently supported by @rollup/plugin-commonjs")}(null==e&&n.path)}
},n.exports),n.exports}var u=c((function(t,e){var n;Object.defineProperty(e,"__esModule",{value:!0}),
e.JsonFormat=void 0,(n=e.JsonFormat||(e.JsonFormat={})).parse=function(t,e){return t.fromJson(JSON.parse(e))},
n.stringify=function(t,e){return JSON.stringify(t.toJson(e))},function(t){t.array=function(t){return new r(t)},
t.map=function(t,e){return new o(t,e)},t.object=function(t){return new i(t)},t.defer=function(t){return{
fromJson:e=>t().fromJson(e),toJson:e=>t().toJson(e)}},t.set=function(t){return new s(t)},t.string=function(){
return new a}}(e.JsonFormat||(e.JsonFormat={}));class r{constructor(t){this.elementFormat=t}fromJson(t){
return t.map((t=>this.elementFormat.fromJson(t)))}toJson(t){return t.map((t=>this.elementFormat.toJson(t)))}}class i{
constructor(t){this.format=t}fromJson(t){const e={};for(const n in this.format)e[n]=this.format[n].fromJson(t[n])
;return e}toJson(t){const e={};for(const n in this.format)e[n]=this.format[n].toJson(t[n]);return e}}class o{
constructor(t,e){this.keyFormat=t,this.valueFormat=e}fromJson(t){
return new Map(t.map((({key:t,value:e})=>[this.keyFormat.fromJson(t),this.valueFormat.fromJson(e)])))}toJson(t){
return[...t.entries()].map((([t,e])=>({key:this.keyFormat.toJson(t),value:this.valueFormat.toJson(e)})))}}class s{
constructor(t){this.format=t}fromJson(t){return new Set(t.map((t=>this.format.fromJson(t))))}toJson(t){
return[...t].map((t=>this.format.toJson(t)))}}class a{fromJson(t){return t}toJson(t){return t}}})),l=c((function(t,e){
Object.defineProperty(e,"__esModule",{value:!0}),e.PackageTree=e.Package=void 0;class n{}e.Package=n,function(t){
t.json=function(){return u.JsonFormat.object({id:u.JsonFormat.string(),
deps:u.JsonFormat.map(u.JsonFormat.string(),u.JsonFormat.string()),path:u.JsonFormat.string()})}
}(n=e.Package||(e.Package={})),(e.PackageTree||(e.PackageTree={})).json=function(){
return u.JsonFormat.map(u.JsonFormat.string(),n.json())}})),h=c((function(t,e){var n
;Object.defineProperty(e,"__esModule",{value:!0}),e.WrapperVfs=e.NoopVfs=e.VfsImpl=e.VfsNode=void 0,function(t){
t.PATH=Symbol("PATH"),t.SYMLINK=Symbol("SYMLINK")}(n=e.VfsNode||(e.VfsNode={}));e.VfsImpl=class{constructor(t){
this.root=t}entry(t){t:for(;;){if(!t.startsWith("/"))throw new Error("Path must be absolute")
;const e=t.split("/").slice(1);let r,i=this.root;for(r=0;r<e.length;r++){if(i.type===n.SYMLINK){
t=[i.path,...e.slice(r)].join("/");continue t}const o=i.extraChildren.get(e[r]);if(!o)break;i=o}if(r<e.length){
if(void 0===i.path)return;return{type:n.PATH,extraChildren:new Map,hardenSymlinks:i.hardenSymlinks,
path:[i.path,...e.slice(r)].join("/")}}return i}}realpath(t){t:for(;;){
if(!t.startsWith("/"))throw new Error("Path must be absolute");const e=t.split("/").slice(1);let r,i=this.root
;for(r=0;r<e.length;r++){if(i.type===n.SYMLINK){t=[i.path,...e.slice(r)].join("/");continue t}
const o=i.extraChildren.get(e[r]);if(!o)break;i=o}if(i.type!==n.SYMLINK){if(r<e.length){if(void 0===i.path)return
;return{hardenSymlinks:i.hardenSymlinks,path:[i.path,...e.slice(r)].join("/")}}return{hardenSymlinks:i.hardenSymlinks,
path:"/"+e.join("/")}}t=[i.path,...e.slice(r)].join("/")}}resolve(t){t:for(;;){
if(!t.startsWith("/"))throw new Error("Path must be absolute");const e=t.split("/").slice(1);let r,i=this.root
;for(r=0;r<e.length;r++){if(i.type===n.SYMLINK){t=[i.path,...e.slice(r)].join("/");continue t}
const o=i.extraChildren.get(e[r]);if(!o)break;i=o}if(i.type!==n.SYMLINK){if(r<e.length){if(void 0===i.path)return
;return{type:n.PATH,extraChildren:new Map,hardenSymlinks:i.hardenSymlinks,path:[i.path,...e.slice(r)].join("/")}}
return i}t=[i.path,...e.slice(r)].join("/")}}print(){return function t(e,r,i){switch(r.type){case n.PATH:{let n
;n=r.path?`${i}${e}/ (${r.path})\n`:`${i}${e}/\n`;for(const[e,o]of r.extraChildren.entries())n+=t(e,o,i+"  ");return n}
case n.SYMLINK:return`${i}${e} -> ${r.path}\n`}}("",this.root,"")}};class r{entry(t){return{type:n.PATH,
extraChildren:new Map,hardenSymlinks:!1,path:t}}realpath(t){return{hardenSymlinks:!1,path:t}}resolve(t){return{
type:n.PATH,extraChildren:new Map,hardenSymlinks:!1,path:t}}}e.NoopVfs=r;e.WrapperVfs=class{constructor(){
this.delegate=new r}entry(t){return this.delegate.entry(t)}realpath(t){return this.delegate.realpath(t)}resolve(t){
return this.delegate.resolve(t)}}})),f=c((function(t,e){Object.defineProperty(e,"__esModule",{value:!0}),
e.patchFs=e.replaceArguments=e.stringPath=void 0;const{fs:n}=process.binding("fs");class r{constructor(t){this.entry=t,
this.atime=new Date(0),this.atimeMs=0n,this.atimeNs=0n,this.birthtime=new Date(0),this.birthtimeMs=0n,
this.birthtimeNs=0n,this.blksize=1024n,this.blocks=1n,this.ctime=new Date(0),this.ctimeMs=0n,this.ctimeNs=0n,
this.dev=0n,this.gid=0n,this.ino=0n,this.mode=493n,this.mtime=new Date(0),this.mtimeMs=0n,this.mtimeNs=0n,this.nlink=1n,
this.rdev=0n,this.size=1024n,this.uid=0n}isFile(){return!1}isDirectory(){return this.entry.type===h.VfsNode.PATH}
isBlockDevice(){return!1}isCharacterDevice(){return!1}isSymbolicLink(){return this.entry.type===h.VfsNode.PATH}isFIFO(){
return!1}isSocket(){return!1}}class a{constructor(t){this.entry=t,this.atime=new Date(0),this.atimeMs=0,
this.birthtime=new Date(0),this.birthtimeMs=0,this.blksize=1024,this.blocks=1,this.ctime=new Date(0),this.ctimeMs=0,
this.dev=0,this.gid=0,this.ino=0,this.mode=493,this.mtime=new Date(0),this.mtimeMs=0,this.nlink=1,this.rdev=0,
this.size=1024,this.uid=0}isFile(){return!1}isDirectory(){return this.entry.type===h.VfsNode.PATH}isBlockDevice(){
return!1}isCharacterDevice(){return!1}isSymbolicLink(){return this.entry.type===h.VfsNode.SYMLINK}isFIFO(){return!1}
isSocket(){return!1}}class c{constructor(t,e){this.dir=t,this.delegate=e,this.extraIterator=void 0}
[Symbol.asyncIterator](){return{next:async()=>{const t=await this.read();return{done:null===t,value:t}},
[Symbol.asyncIterator](){return this}}}close(t){
return void 0!==this.delegate?this.delegate.close.apply(this.delegate,arguments):t?void setImmediate((()=>t(void 0))):Promise.resolve()
}closeSync(){if(void 0!==this.delegate)return this.delegate.closeSync.apply(this.delegate,arguments)}read(t){
if(!t)return(async()=>{if(void 0!==this.delegate&&void 0===this.extraIterator){
const t=await this.delegate.read.apply(this.delegate,arguments);if(null!==t)return t}
void 0===this.extraIterator&&(this.extraIterator=this.dir.extraChildren.entries());const t=this.extraIterator.next()
;return t.done?null:u(t.value[0],t.value[1])})()
;if(void 0!==this.delegate&&void 0===this.extraIterator)this.delegate.read(((e,n)=>{null===e&&null===n||t(e,n),
this.extraIterator=this.dir.extraChildren.entries();const r=this.extraIterator.next()
;r.done?t(null,null):t(null,u(r.value[0],r.value[1]))}));else{
void 0===this.extraIterator&&(this.extraIterator=this.dir.extraChildren.entries());const e=this.extraIterator.next()
;e.done?setImmediate((()=>t(null,null))):setImmediate((()=>t(null,u(e.value[0],e.value[1]))))}}readSync(){
if(void 0!==this.delegate&&void 0===this.extraIterator){const t=this.delegate.readSync.apply(this.delegate,arguments)
;if(null!==t)return t}void 0===this.extraIterator&&(this.extraIterator=this.dir.extraChildren.entries())
;const t=this.extraIterator.next();return t.done?null:u(t.value[0],t.value[1])}}function u(t,e){switch(e.type){
case h.VfsNode.PATH:return new i.default.Dirent(t,n.UV_DIRENT_DIR);case h.VfsNode.SYMLINK:
return new i.default.Dirent(t,n.UV_DIRENT_LINK)}}function l(t){if(t instanceof Buffer&&(t=t.toString()),
t instanceof o.default.URL){if("file:"!==t.protocol)throw new Error(`Invalid protocol: ${t.protocol}`)
;t=o.default.fileURLToPath(t)}return s.default.resolve(t)}function f(t,e,n){return function(){const r=[...arguments]
;for(const e of n){const n=l(r[e]),i=t.resolve(n);void 0!==i.path&&n!==i.path&&(r[e]=i.path)}return e.apply(this,r)}}
function p(t,e){return function(n,o,s){const c=l(n),u=t.entry(c);if("function"==typeof o&&(s=o,o={}),
u)if(u.type===h.VfsNode.SYMLINK||void 0===u.path)setImmediate((()=>s(null,o.bigint?new r(u):new a(u))));else if(u.hardenSymlinks)return void i.default.stat(u.path,o,s)
;return u&&u.path,e.apply(this,arguments)}}function d(t,e){return function(n,o){const s=l(n),c=t.entry(s);if(c){
if(c.type===h.VfsNode.SYMLINK||void 0===c.path)return o.bigint?new r(c):new a(c)
;if(c.hardenSymlinks)return i.default.statSync(c.path,o)}return c&&c.path,e.apply(this,arguments)}}function m(t,e){
return function(n,r,i){const o=l(n);"function"==typeof r?(i=r,r={}):r="string"==typeof r?{encoding:r}:{}
;const s=t.entry(o)
;if(s&&s.type===h.VfsNode.SYMLINK)return void("buffer"===r.encoding?setImmediate((()=>i(null,Buffer.from(s.path)))):setImmediate((()=>i(null,s.path))))
;const a=[...arguments];return s&&o!==s.path&&(a[0]=s.path),e.apply(this,a)}}function y(t,e){return function(n,r){
const i=l(n);r="string"==typeof r?{encoding:r}:{};const o=t.entry(i)
;if(o&&o.type===h.VfsNode.SYMLINK)return"buffer"===r.encoding?Buffer.from(o.path):o.path;const s=[...arguments]
;return o&&i!==o.path&&(s[0]=o.path),e.apply(this,s)}}e.stringPath=l,e.replaceArguments=f,e.patchFs=function(t,e){
e.access=function(t,e){return f(t,e,[0])}(t,e.access),e.accessSync=function(t,e){return f(t,e,[0])}(t,e.accessSync),
e.appendFile=function(t,e){return f(t,e,[0])}(t,e.appendFile),e.appendFileSync=function(t,e){return f(t,e,[0])
}(t,e.appendFileSync),e.chmod=function(t,e){return f(t,e,[0])}(t,e.chmod),e.chmodSync=function(t,e){return f(t,e,[0])
}(t,e.chmodSync),e.chown=function(t,e){return f(t,e,[0])}(t,e.chown),e.chownSync=function(t,e){return f(t,e,[0])
}(t,e.chownSync),e.copyFile=function(t,e){return f(t,e,[0,1])}(t,e.copyFile),e.copyFileSync=function(t,e){
return f(t,e,[0,1])}(t,e.copyFileSync),e.createReadStream=function(t,e){return f(t,e,[0])}(t,e.createReadStream),
e.createWriteStream=function(t,e){return f(t,e,[0])}(t,e.createWriteStream),e.exists=function(t,e){return f(t,e,[0])
}(t,e.exists),e.existsSync=function(t,e){return f(t,e,[0])}(t,e.existsSync),e.link=function(t,e){return f(t,e,[0,1])
}(t,e.link),e.linkSync=function(t,e){return f(t,e,[0,1])}(t,e.linkSync),e.lstat=p(t,e.lstat),
e.lstatSync=d(t,e.lstatSync),e.mkdir=function(t,e){return f(t,e,[0])}(t,e.mkdir),e.mkdirSync=function(t,e){
return f(t,e,[0])}(t,e.mkdirSync),e.open=function(t,e){return function(n){const r=l(n),i=t.resolve(r),o=[...arguments]
;return i&&void 0===i.path||r!==i.path&&(o[0]=i.path),e.apply(this,o)}}(t,e.open),e.openSync=function(t,e){
return function(n){const r=l(n),i=t.resolve(r),o=[...arguments];return i&&void 0===i.path||r!==i.path&&(o[0]=i.path),
e.apply(this,o)}}(t,e.openSync),e.opendir=function(t,e){return function(n,r,i){const o=l(n);"function"==typeof r&&(i=r)
;const s=t.resolve(o);if(s&&void 0===s.path)return void setImmediate((()=>i(null,new c(s,void 0))))
;const a=[...arguments]
;return s&&o!==s.path&&(a[0]=s.path),s&&s.extraChildren.size&&(a["function"==typeof a[1]?1:2]=function(t,e){
if(t)return i.apply(this,arguments);i(null,new c(s,e))}),e.apply(this,a)}}(t,e.opendir),e.opendirSync=function(t,e){
return function(n){const r=l(n),i=t.resolve(r);if(i&&void 0===i.path)return new c(i,void 0);const o=[...arguments]
;i&&r!==i.path&&(o[0]=i.path);const s=e.apply(this,o);return i&&i.extraChildren.size?new c(i,s):s}}(t,e.opendirSync),
e.readdir=function(t,e){return function(n,r,i){const o=l(n);"function"==typeof r?(i=r,r={}):r="string"==typeof r?{
encoding:r}:{};const s=t.resolve(o);let a=[]
;if(s&&s.extraChildren.size&&(a=r.withFileTypes?[...s.extraChildren.entries()].map((([t,e])=>u(t,e))):"buffer"===r.encoding?[...s.extraChildren.keys()].map((t=>Buffer.from(t))):[...s.extraChildren.keys()]),
s&&void 0===s.path)return void setImmediate((()=>i(null,a)));const c=[...arguments];return s&&o!==s.path&&(c[0]=s.path),
a.length&&(c["function"==typeof c[1]?1:2]=function(t,e){if(t)return i.apply(this,arguments);i(null,[...e,...a])}),
e.apply(this,c)}}(t,e.readdir),e.readdirSync=function(t,e){return function(n,r){const i=l(n);r="string"==typeof r?{
encoding:r}:{};const o=t.resolve(i);let s=[]
;if(o&&o.extraChildren.size&&(s=r.withFileTypes?[...o.extraChildren.entries()].map((([t,e])=>u(t,e))):"buffer"===r.encoding?[...o.extraChildren.keys()].map((t=>Buffer.from(t))):[...o.extraChildren.keys()]),
o&&void 0===o.path)return s;const a=[...arguments];o&&i!==o.path&&(a[0]=o.path);const c=e.apply(this,a)
;return s.length?[...c,...s]:c}}(t,e.readdirSync),e.readFile=function(t,e){return f(t,e,[0])}(t,e.readFile),
e.readFileSync=function(t,e){return f(t,e,[0])}(t,e.readFileSync),e.readlink=m(t,e.readlink),
e.readlinkSync=y(t,e.readlinkSync),e.realpath=function(t,e){function n(n,r,i){const o=l(n);"function"==typeof r&&(i=r)
;const s=t.realpath(o),a=[...arguments]
;s&&o!=s.path&&(a[0]=s.path),s.hardenSymlinks&&(a["function"==typeof a[1]?1:2]=function(t){
if(t)return i.apply(this,arguments);i(null,"buffer"===r?Buffer.from(s.path):s.path)}),e.apply(this,a)}
return n.native=e.native,n}(t,e.realpath),e.realpathSync=function(t,e){function n(n,r){
const i=l(n),o=t.realpath(i),s=[...arguments];o&&i!=o.path&&(s[0]=o.path);const a=e.apply(this,s)
;return o?.hardenSymlinks?"buffer"===r?Buffer.from(o.path):o.path:a}return n.native=e.native,n}(t,e.realpathSync),
e.rename=function(t,e){return f(t,e,[0,1])}(t,e.rename),e.renameSync=function(t,e){return f(t,e,[0,1])}(t,e.renameSync),
e.rmdir=function(t,e){return f(t,e,[0])}(t,e.rmdir),e.rmdirSync=function(t,e){return f(t,e,[0])}(t,e.rmdirSync),
e.rm=function(t,e){return f(t,e,[0])}(t,e.rm),e.rmSync=function(t,e){return f(t,e,[0])}(t,e.rmSync),
e.stat=function(t,e){return function(n,i,o){const s=l(n),c=t.resolve(s);if("function"==typeof i&&(o=i,i={}),
c&&void 0===c.path)return void setImmediate((()=>o(null,i.bigint?new r(c):new a(c))));const u=[...arguments]
;return c&&s!==c.path&&(u[0]=c.path),e.apply(this,u)}}(t,e.stat),e.statSync=function(t,e){return function(n,i){
const o=l(n),s=t.resolve(o);if(s&&void 0===s.path)return i?.bigint?new r(s):new a(s);const c=[...arguments]
;return s&&o!==s.path&&(c[0]=s.path),e.apply(this,c)}}(t,e.statSync),e.symlink=function(t,e){return f(t,e,[0])
}(t,e.symlink),e.symlinkSync=function(t,e){return f(t,e,[0])}(t,e.symlinkSync),e.truncate=function(t,e){
return f(t,e,[0])}(t,e.truncate),e.truncateSync=function(t,e){return f(t,e,[0])}(t,e.truncateSync),
e.unlink=function(t,e){return f(t,e,[0])}(t,e.unlink),e.unlinkSync=function(t,e){return f(t,e,[0])}(t,e.unlinkSync),
e.utimes=function(t,e){return f(t,e,[0])}(t,e.utimes),e.utimesSync=function(t,e){return f(t,e,[0])}(t,e.unlinkSync),
e.writeFile=function(t,e){return f(t,e,[0])}(t,e.writeFile),e.writeFileSync=function(t,e){return f(t,e,[0])
}(t,e.writeFileSync)}})),p=c((function(t,e){Object.defineProperty(e,"__esModule",{value:!0}),e.patchFsPromises=void 0,
e.patchFsPromises=function(t,e){e.access=function(t,e){return f.replaceArguments(t,e,[0])}(t,i.default.promises.access),
e.appendFile=function(t,e){return f.replaceArguments(t,e,[0])}(t,i.default.promises.appendFile),e.chmod=function(t,e){
return f.replaceArguments(t,e,[0])}(t,e.chmod),e.chown=function(t,e){return f.replaceArguments(t,e,[0])}(t,e.chown),
e.copyFile=function(t,e){return f.replaceArguments(t,e,[0,1])}(t,e.copyFile),e.cp=function(t,e){
return f.replaceArguments(t,e,[0,1])}(t,e.cp),e.lutimes=function(t,e){return f.replaceArguments(t,e,[0])}(t,e.lutimes)}
})),d=c((function(t,e){Object.defineProperty(e,"__esModule",{value:!0}),e.createVfs=void 0;class n extends Error{}
function r(t,e){const n=e.split("/").slice(1);for(let e=0;e<n.length;e++){let r=t.extraChildren.get(n[e]);r||(r={
type:h.VfsNode.PATH,hardenSymlinks:!1,extraChildren:new Map,path:"/"+n.slice(0,e+1).join("/")},
t.extraChildren.set(n[e],r)),t=r}return t.hardenSymlinks=!0,t}function i(t,e,r){const i=e.split("/")
;for(let e=0;e<i.length-1;e++){let r=t.extraChildren.get(i[e]);if(r){if(r.type!==h.VfsNode.PATH)throw new n}else r={
type:h.VfsNode.PATH,hardenSymlinks:!1,extraChildren:new Map,path:void 0},t.extraChildren.set(i[e],r);t=r}
t.extraChildren.set(i[i.length-1],{type:h.VfsNode.SYMLINK,path:r})}e.createVfs=function(t){const e={type:h.VfsNode.PATH,
hardenSymlinks:!1,extraChildren:new Map,path:"/"};for(const[o,a]of t.entries()){
const c=r(e,s.default.resolve(a.path)),u={type:h.VfsNode.PATH,hardenSymlinks:!1,extraChildren:new Map,path:void 0}
;c.extraChildren.set("node_modules",u);for(const[e,r]of a.deps)try{i(u,e,s.default.resolve(t.get(r).path))}catch(t){
if(!(t instanceof n))throw t;throw new Error(`Dependency "${e}" of "${o}" conflicts with another`)}}
return new h.VfsImpl(e)}})),m=c((function(t,e){Object.defineProperty(e,"__esModule",{value:!0})
;const n=process.env.NODE_FS_PACKAGE_MANIFEST;if(!n)throw new Error("NODE_FS_PACKAGE_MANIFEST is not set")
;const r=u.JsonFormat.parse(l.PackageTree.json(),i.default.readFileSync(n,"utf8")),o=d.createVfs(r)
;"true"===process.env.NODE_FS_TRACE&&process.stderr.write(o.print()),f.patchFs(o,i.default),
p.patchFsPromises(o,i.default.promises)})),y=a(m);module.exports=y;
