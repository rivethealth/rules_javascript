"use strict";var t=require("fs"),n=require("url"),e=require("path");function r(t){if(t&&t.__esModule)return t
;var n=Object.create(null);return t&&Object.keys(t).forEach((function(e){if("default"!==e){
var r=Object.getOwnPropertyDescriptor(t,e);Object.defineProperty(n,e,r.get?r:{enumerable:!0,get:function(){return t[e]}
})}})),n.default=t,Object.freeze(n)}var i,o,s,a=r(t),c=r(e);!function(t){t.parse=function(t,n){
return t.fromJson(JSON.parse(n))},t.stringify=function(t,n){return JSON.stringify(t.toJson(n))}}(i||(i={})),function(t){
t.array=function(t){return new u(t)},t.map=function(t,n){return new l(t,n)},t.object=function(t){return new h(t)},
t.defer=function(t){return{fromJson:n=>t().fromJson(n),toJson:n=>t().toJson(n)}},t.set=function(t){return new f(t)},
t.string=function(){return new p}}(i||(i={}));class u{constructor(t){this.elementFormat=t}fromJson(t){
return t.map((t=>this.elementFormat.fromJson(t)))}toJson(t){return t.map((t=>this.elementFormat.toJson(t)))}}class h{
constructor(t){this.format=t}fromJson(t){const n={};for(const e in this.format)n[e]=this.format[e].fromJson(t[e])
;return n}toJson(t){const n={};for(const e in this.format)n[e]=this.format[e].toJson(t[e]);return n}}class l{
constructor(t,n){this.keyFormat=t,this.valueFormat=n}fromJson(t){
return new Map(t.map((({key:t,value:n})=>[this.keyFormat.fromJson(t),this.valueFormat.fromJson(n)])))}toJson(t){
return[...t.entries()].map((([t,n])=>({key:this.keyFormat.toJson(t),value:this.valueFormat.toJson(n)})))}}class f{
constructor(t){this.format=t}fromJson(t){return new Set(t.map((t=>this.format.fromJson(t))))}toJson(t){
return[...t].map((t=>this.format.toJson(t)))}}class p{fromJson(t){return t}toJson(t){return t}}class d{}!function(t){
t.json=function(){return i.object({id:i.string(),deps:i.map(i.string(),i.string()),path:i.string()})}}(d||(d={})),
function(t){t.json=function(){return i.map(i.string(),d.json())}}(o||(o={})),function(t){t.PATH=Symbol("PATH"),
t.SYMLINK=Symbol("SYMLINK")}(s||(s={}));class y{constructor(t){this.root=t}entry(t){t:for(;;){
if(!t.startsWith("/"))throw new Error("Path must be absolute");const n=t.split("/").slice(1);let e,r=this.root
;for(e=0;e<n.length;e++){if(r.type===s.SYMLINK){t=[r.path,...n.slice(e)].join("/");continue t}
const i=r.extraChildren.get(n[e]);if(!i)break;r=i}if(e<n.length){if(void 0===r.path)return;return{type:s.PATH,
extraChildren:new Map,hardenSymlinks:r.hardenSymlinks,path:[r.path,...n.slice(e)].join("/")}}return r}}realpath(t){
t:for(;;){if(!t.startsWith("/"))throw new Error("Path must be absolute");const n=t.split("/").slice(1);let e,r=this.root
;for(e=0;e<n.length;e++){if(r.type===s.SYMLINK){t=[r.path,...n.slice(e)].join("/");continue t}
const i=r.extraChildren.get(n[e]);if(!i)break;r=i}if(r.type!==s.SYMLINK){if(e<n.length){if(void 0===r.path)return
;return{hardenSymlinks:r.hardenSymlinks,path:[r.path,...n.slice(e)].join("/")}}return{hardenSymlinks:r.hardenSymlinks,
path:"/"+n.join("/")}}t=[r.path,...n.slice(e)].join("/")}}resolve(t){t:for(;;){
if(!t.startsWith("/"))throw new Error("Path must be absolute");const n=t.split("/").slice(1);let e,r=this.root
;for(e=0;e<n.length;e++){if(r.type===s.SYMLINK){t=[r.path,...n.slice(e)].join("/");continue t}
const i=r.extraChildren.get(n[e]);if(!i)break;r=i}if(r.type!==s.SYMLINK){if(e<n.length){if(void 0===r.path)return
;return{type:s.PATH,extraChildren:new Map,hardenSymlinks:r.hardenSymlinks,path:[r.path,...n.slice(e)].join("/")}}
return r}t=[r.path,...n.slice(e)].join("/")}}print(){return function t(n,e,r){switch(e.type){case s.PATH:{let i
;i=e.path?`${r}${n}/ (${e.path})\n`:`${r}${n}/\n`;for(const[n,o]of e.extraChildren.entries())i+=t(n,o,r+"  ");return i}
case s.SYMLINK:return`${r}${n} -> ${e.path}\n`}}("",this.root,"")}}const{fs:m}=process.binding("fs");class S{
constructor(t){this.entry=t,this.atime=new Date(0),this.atimeMs=0n,this.atimeNs=0n,this.birthtime=new Date(0),
this.birthtimeMs=0n,this.birthtimeNs=0n,this.blksize=1024n,this.blocks=1n,this.ctime=new Date(0),this.ctimeMs=0n,
this.ctimeNs=0n,this.dev=0n,this.gid=0n,this.ino=0n,this.mode=493n,this.mtime=new Date(0),this.mtimeMs=0n,
this.mtimeNs=0n,this.nlink=1n,this.rdev=0n,this.size=1024n,this.uid=0n}isFile(){return!1}isDirectory(){
return this.entry.type===s.PATH}isBlockDevice(){return!1}isCharacterDevice(){return!1}isSymbolicLink(){
return this.entry.type===s.PATH}isFIFO(){return!1}isSocket(){return!1}}class v{constructor(t){this.entry=t,
this.atime=new Date(0),this.atimeMs=0,this.birthtime=new Date(0),this.birthtimeMs=0,this.blksize=1024,this.blocks=1,
this.ctime=new Date(0),this.ctimeMs=0,this.dev=0,this.gid=0,this.ino=0,this.mode=493,this.mtime=new Date(0),
this.mtimeMs=0,this.nlink=1,this.rdev=0,this.size=1024,this.uid=0}isFile(){return!1}isDirectory(){
return this.entry.type===s.PATH}isBlockDevice(){return!1}isCharacterDevice(){return!1}isSymbolicLink(){
return this.entry.type===s.SYMLINK}isFIFO(){return!1}isSocket(){return!1}}class w{constructor(t,n){this.dir=t,
this.delegate=n,this.extraIterator=void 0}[Symbol.asyncIterator](){return{next:async()=>{const t=await this.read()
;return{done:null===t,value:t}},[Symbol.asyncIterator](){return this}}}close(t){
return void 0!==this.delegate?this.delegate.close.apply(this.delegate,arguments):t?void setImmediate((()=>t(void 0))):Promise.resolve()
}closeSync(){if(void 0!==this.delegate)return this.delegate.closeSync.apply(this.delegate,arguments)}read(t){
if(!t)return(async()=>{if(void 0!==this.delegate&&void 0===this.extraIterator){
const t=await this.delegate.read.apply(this.delegate,arguments);if(null!==t)return t}
void 0===this.extraIterator&&(this.extraIterator=this.dir.extraChildren.entries());const t=this.extraIterator.next()
;return t.done?null:g(t.value[0],t.value[1])})()
;if(void 0!==this.delegate&&void 0===this.extraIterator)this.delegate.read(((n,e)=>{null===n&&null===e||t(n,e),
this.extraIterator=this.dir.extraChildren.entries();const r=this.extraIterator.next()
;r.done?t(null,null):t(null,g(r.value[0],r.value[1]))}));else{
void 0===this.extraIterator&&(this.extraIterator=this.dir.extraChildren.entries());const n=this.extraIterator.next()
;n.done?setImmediate((()=>t(null,null))):setImmediate((()=>t(null,g(n.value[0],n.value[1]))))}}readSync(){
if(void 0!==this.delegate&&void 0===this.extraIterator){const t=this.delegate.readSync.apply(this.delegate,arguments)
;if(null!==t)return t}void 0===this.extraIterator&&(this.extraIterator=this.dir.extraChildren.entries())
;const t=this.extraIterator.next();return t.done?null:g(t.value[0],t.value[1])}}function g(t,n){switch(n.type){
case s.PATH:return new a.Dirent(t,m.UV_DIRENT_DIR);case s.SYMLINK:return new a.Dirent(t,m.UV_DIRENT_LINK)}}
function k(t){if(t instanceof Buffer&&(t=t.toString()),t instanceof n.URL){
if("file:"!==t.protocol)throw new Error(`Invalid protocol: ${t.protocol}`);t=n.fileURLToPath(t)}return c.resolve(t)}
function x(t,n,e){return function(){const r=[...arguments];for(const n of e){const e=k(r[n]),i=t.resolve(e)
;void 0!==i.path&&e!==i.path&&(r[n]=i.path)}return n.apply(this,r)}}class I extends Error{}function b(t,n){
const e=n.split("/").slice(1);for(let n=0;n<e.length;n++){let r=t.extraChildren.get(e[n]);r||(r={type:s.PATH,
hardenSymlinks:!1,extraChildren:new Map,path:"/"+e.slice(0,n+1).join("/")},t.extraChildren.set(e[n],r)),t=r}
return t.hardenSymlinks=!0,t}function F(t,n,e){const r=n.split("/");for(let n=0;n<r.length-1;n++){
let e=t.extraChildren.get(r[n]);if(e){if(e.type!==s.PATH)throw new I}else e={type:s.PATH,hardenSymlinks:!1,
extraChildren:new Map,path:void 0},t.extraChildren.set(r[n],e);t=e}t.extraChildren.set(r[r.length-1],{type:s.SYMLINK,
path:e})}const C=process.env.NODE_FS_PACKAGE_MANIFEST;if(!C)throw new Error("NODE_FS_PACKAGE_MANIFEST is not set")
;const M=function(t){const n={type:s.PATH,hardenSymlinks:!1,extraChildren:new Map,path:"/"}
;for(const[e,r]of t.entries()){const i=b(n,c.resolve(r.path)),o={type:s.PATH,hardenSymlinks:!1,extraChildren:new Map,
path:void 0};i.extraChildren.set("node_modules",o);for(const[n,i]of r.deps)try{F(o,n,c.resolve(t.get(i).path))}catch(t){
if(!(t instanceof I))throw t;throw new Error(`Dependency "${n}" of "${e}" conflicts with another`)}}return new y(n)
}(i.parse(o.json(),a.readFileSync(C,"utf8")));"true"===process.env.NODE_FS_TRACE2&&process.stderr.write(M.print()),
function(t,n){n.access=function(t,n){return x(t,n,[0])}(t,n.access),n.accessSync=function(t,n){return x(t,n,[0])
}(t,n.accessSync),n.appendFile=function(t,n){return x(t,n,[0])}(t,n.appendFile),n.appendFileSync=function(t,n){
return x(t,n,[0])}(t,n.appendFileSync),n.chmod=function(t,n){return x(t,n,[0])}(t,n.chmod),n.chmodSync=function(t,n){
return x(t,n,[0])}(t,n.chmodSync),n.chown=function(t,n){return x(t,n,[0])}(t,n.chown),n.chownSync=function(t,n){
return x(t,n,[0])}(t,n.chownSync),n.copyFile=function(t,n){return x(t,n,[0,1])}(t,n.copyFile),
n.copyFileSync=function(t,n){return x(t,n,[0,1])}(t,n.copyFileSync),n.createReadStream=function(t,n){return x(t,n,[0])
}(t,n.createReadStream),n.createWriteStream=function(t,n){return x(t,n,[0])}(t,n.createWriteStream),
n.exists=function(t,n){return x(t,n,[0])}(t,n.exists),n.existsSync=function(t,n){return x(t,n,[0])}(t,n.existsSync),
n.link=function(t,n){return x(t,n,[0,1])}(t,n.link),n.linkSync=function(t,n){return x(t,n,[0,1])}(t,n.linkSync),
n.lstat=function(t,n){return function(e,r,i){const o=k(e),c=t.entry(o);if("function"==typeof r&&(i=r,r={}),
c)if(c.type===s.SYMLINK||void 0===c.path)setImmediate((()=>i(null,r.bigint?new S(c):new v(c))));else if(c.hardenSymlinks)return void a.stat(c.path,r,i)
;return c&&c.path,n.apply(this,arguments)}}(t,n.lstat),n.lstatSync=function(t,n){return function(e,r){
const i=k(e),o=t.entry(i);if(o){if(o.type===s.SYMLINK||void 0===o.path)return r.bigint?new S(o):new v(o)
;if(o.hardenSymlinks)return a.statSync(o.path,r)}return o&&o.path,n.apply(this,arguments)}}(t,n.lstatSync),
n.mkdir=function(t,n){return x(t,n,[0])}(t,n.mkdir),n.mkdirSync=function(t,n){return x(t,n,[0])}(t,n.mkdirSync),
n.open=function(t,n){return function(e){const r=k(e),i=t.resolve(r),o=[...arguments]
;return i&&void 0===i.path||r!==i.path&&(o[0]=i.path),n.apply(this,o)}}(t,n.open),n.openSync=function(t,n){
return function(e){const r=k(e),i=t.resolve(r),o=[...arguments];return i&&void 0===i.path||r!==i.path&&(o[0]=i.path),
n.apply(this,o)}}(t,n.openSync),n.opendir=function(t,n){return function(e,r,i){const o=k(e);"function"==typeof r&&(i=r)
;const s=t.resolve(o);if(s&&void 0===s.path)return void setImmediate((()=>i(null,new w(s,void 0))))
;const a=[...arguments]
;return s&&o!==s.path&&(a[0]=s.path),s&&s.extraChildren.size&&(a["function"==typeof a[1]?1:2]=function(t,n){
if(t)return i.apply(this,arguments);i(null,new w(s,n))}),n.apply(this,a)}}(t,n.opendir),n.opendirSync=function(t,n){
return function(e){const r=k(e),i=t.resolve(r);if(i&&void 0===i.path)return new w(i,void 0);const o=[...arguments]
;i&&r!==i.path&&(o[0]=i.path);const s=n.apply(this,o);return i&&i.extraChildren.size?new w(i,s):s}}(t,n.opendirSync),
n.readdir=function(t,n){return function(e,r,i){const o=k(e);"function"==typeof r?(i=r,r={}):r="string"==typeof r?{
encoding:r}:{};const s=t.resolve(o);let a=[]
;if(s&&s.extraChildren.size&&(a=r.withFileTypes?[...s.extraChildren.entries()].map((([t,n])=>g(t,n))):"buffer"===r.encoding?[...s.extraChildren.keys()].map((t=>Buffer.from(t))):[...s.extraChildren.keys()]),
s&&void 0===s.path)return void setImmediate((()=>i(null,a)));const c=[...arguments];return s&&o!==s.path&&(c[0]=s.path),
a.length&&(c["function"==typeof c[1]?1:2]=function(t,n){if(t)return i.apply(this,arguments);i(null,[...n,...a])}),
n.apply(this,c)}}(t,n.readdir),n.readdirSync=function(t,n){return function(e,r){const i=k(e);r="string"==typeof r?{
encoding:r}:{};const o=t.resolve(i);let s=[]
;if(o&&o.extraChildren.size&&(s=r.withFileTypes?[...o.extraChildren.entries()].map((([t,n])=>g(t,n))):"buffer"===r.encoding?[...o.extraChildren.keys()].map((t=>Buffer.from(t))):[...o.extraChildren.keys()]),
o&&void 0===o.path)return s;const a=[...arguments];o&&i!==o.path&&(a[0]=o.path);const c=n.apply(this,a)
;return s.length?[...c,...s]:c}}(t,n.readdirSync),n.readFile=function(t,n){return x(t,n,[0])}(t,n.readFile),
n.readFileSync=function(t,n){return x(t,n,[0])}(t,n.readFileSync),n.readlink=function(t,n){return function(e,r,i){
const o=k(e);"function"==typeof r?(i=r,r={}):r="string"==typeof r?{encoding:r}:{};const a=t.entry(o)
;if(a&&a.type===s.SYMLINK)return void("buffer"===r.encoding?setImmediate((()=>i(null,Buffer.from(a.path)))):setImmediate((()=>i(null,a.path))))
;const c=[...arguments];return a&&o!==a.path&&(c[0]=a.path),n.apply(this,c)}}(t,n.readlink),
n.readlinkSync=function(t,n){return function(e,r){const i=k(e);r="string"==typeof r?{encoding:r}:{};const o=t.entry(i)
;if(o&&o.type===s.SYMLINK)return"buffer"===r.encoding?Buffer.from(o.path):o.path;const a=[...arguments]
;return o&&i!==o.path&&(a[0]=o.path),n.apply(this,a)}}(t,n.readlinkSync),n.realpath=function(t,n){function e(e,r,i){
const o=k(e);"function"==typeof r&&(i=r);const s=t.realpath(o),a=[...arguments];s&&o!=s.path&&(a[0]=s.path),
s.hardenSymlinks&&(a["function"==typeof a[1]?1:2]=function(t){if(t)return i.apply(this,arguments)
;i(null,"buffer"===r?Buffer.from(s.path):s.path)}),n.apply(this,a)}return e.native=n.native,e}(t,n.realpath),
n.realpathSync=function(t,n){function e(e,r){const i=k(e),o=t.realpath(i),s=[...arguments];o&&i!=o.path&&(s[0]=o.path)
;const a=n.apply(this,s);return o?.hardenSymlinks?"buffer"===r?Buffer.from(o.path):o.path:a}return e.native=n.native,e
}(t,n.realpathSync),n.rename=function(t,n){return x(t,n,[0,1])}(t,n.rename),n.renameSync=function(t,n){
return x(t,n,[0,1])}(t,n.renameSync),n.rmdir=function(t,n){return x(t,n,[0])}(t,n.rmdir),n.rmdirSync=function(t,n){
return x(t,n,[0])}(t,n.rmdirSync),n.rm=function(t,n){return x(t,n,[0])}(t,n.rm),n.rmSync=function(t,n){return x(t,n,[0])
}(t,n.rmSync),n.stat=function(t,n){return function(e,r,i){const o=k(e),s=t.resolve(o);if("function"==typeof r&&(i=r,
r={}),s&&void 0===s.path)return void setImmediate((()=>i(null,r.bigint?new S(s):new v(s))));const a=[...arguments]
;return s&&o!==s.path&&(a[0]=s.path),n.apply(this,a)}}(t,n.stat),n.statSync=function(t,n){return function(e,r){
const i=k(e),o=t.resolve(i);if(o&&void 0===o.path)return r?.bigint?new S(o):new v(o);const s=[...arguments]
;return o&&i!==o.path&&(s[0]=o.path),n.apply(this,s)}}(t,n.statSync),n.symlink=function(t,n){return x(t,n,[0])
}(t,n.symlink),n.symlinkSync=function(t,n){return x(t,n,[0])}(t,n.symlinkSync),n.truncate=function(t,n){
return x(t,n,[0])}(t,n.truncate),n.truncateSync=function(t,n){return x(t,n,[0])}(t,n.truncateSync),
n.unlink=function(t,n){return x(t,n,[0])}(t,n.unlink),n.unlinkSync=function(t,n){return x(t,n,[0])}(t,n.unlinkSync),
n.utimes=function(t,n){return x(t,n,[0])}(t,n.utimes),n.utimesSync=function(t,n){return x(t,n,[0])}(t,n.unlinkSync),
n.writeFile=function(t,n){return x(t,n,[0])}(t,n.writeFile),n.writeFileSync=function(t,n){return x(t,n,[0])
}(t,n.writeFileSync)}(M,require("fs")),function(n,e){e.access=function(t,n){return x(t,n,[0])}(n,t.promises.access),
e.appendFile=function(t,n){return x(t,n,[0])}(n,t.promises.appendFile),e.chmod=function(t,n){return x(t,n,[0])
}(n,e.chmod),e.chown=function(t,n){return x(t,n,[0])}(n,e.chown),e.copyFile=function(t,n){return x(t,n,[0,1])
}(n,e.copyFile),e.cp=function(t,n){return x(t,n,[0,1])}(n,e.cp),e.lutimes=function(t,n){return x(t,n,[0])}(n,e.lutimes)
}(M,require("fs").promises);
