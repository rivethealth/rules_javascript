"use strict";var e=require("path"),t=require("fs"),r=require("module");function n(e){
return e&&"object"==typeof e&&"default"in e?e:{default:e}}function o(e){if(e&&e.__esModule)return e
;var t=Object.create(null);return e&&Object.keys(e).forEach((function(r){if("default"!==r){
var n=Object.getOwnPropertyDescriptor(e,r);Object.defineProperty(t,r,n.get?n:{enumerable:!0,get:function(){return e[r]}
})}})),t.default=e,Object.freeze(t)}var s=n(e),a=o(t),i=n(r);function u(e,t,r){return e(r={path:t,exports:{},
require:function(e,t){return function(){
throw new Error("Dynamic requires are not currently supported by @rollup/plugin-commonjs")}(null==t&&r.path)}
},r.exports),r.exports}var c=u((function(e,t){Object.defineProperty(t,"__esModule",{value:!0}),t.Trie=void 0
;t.Trie=class{constructor(){this.data={children:new Map}}getClosest(e){let t,r=this.data;for(t=0;t<e.length&&r;t++){
const n=e[t],o=r.children.get(n);if(!o)break;r=o}return{rest:e.slice(t),value:r.value}}put(e,t){let r=this.data
;for(const t of e){let e=r.children.get(t);e||(e={children:new Map},r.children.set(t,e)),r=e}r.value=t}}
})),f=u((function(e,t){function r(e){return e?e.split("/"):[]}function n(e){
return(e=s.default.resolve(e)).split("/").slice(1)}Object.defineProperty(t,"__esModule",{value:!0}),t.Resolver=void 0
;class o{constructor(e){this.packages=e}resolve(e,t){
if(t.startsWith(".")||t.startsWith("/"))throw new Error(`Specifier "${t}" is not for a package`)
;const{value:o}=this.packages.getClosest(n(e));if(!o)throw new Error(`File "${e}" is not part of any known package`)
;const{rest:s,value:a}=o.deps.getClosest(r(t))
;if(!a)throw new Error(`Package "${o.id}" does not have any dependency for "${t}"`);return{package:a,inner:s.join("/")}}
static create(e,t){const a=e=>s.default.resolve(t?`${process.env.RUNFILES_DIR}/${e}`:e),i=new c.Trie
;for(const[t,o]of e.entries()){const s=n(a(o.path)),u=new c.Trie;for(const[n,s]of o.deps.entries()){const o=e.get(s)
;if(!o)throw new Error(`Package "${s}" referenced by "${t}" does not exist`);const i=a(o.path);u.put(r(n),i)}i.put(s,{
id:t,deps:u})}return new o(i)}}t.Resolver=o})),l=u((function(e,t){var r;Object.defineProperty(t,"__esModule",{value:!0
}),t.JsonFormat=void 0,(r=t.JsonFormat||(t.JsonFormat={})).parse=function(e,t){return e.fromJson(JSON.parse(t))},
r.stringify=function(e,t){return JSON.stringify(e.toJson(t))},function(e){e.array=function(e){return new n(e)},
e.map=function(e,t){return new s(e,t)},e.object=function(e){return new o(e)},e.defer=function(e){return{
fromJson:t=>e().fromJson(t),toJson:t=>e().toJson(t)}},e.set=function(e){return new a(e)},e.string=function(){
return new i}}(t.JsonFormat||(t.JsonFormat={}));class n{constructor(e){this.elementFormat=e}fromJson(e){
return e.map((e=>this.elementFormat.fromJson(e)))}toJson(e){return e.map((e=>this.elementFormat.toJson(e)))}}class o{
constructor(e){this.format=e}fromJson(e){const t={};for(const r in this.format)t[r]=this.format[r].fromJson(e[r])
;return t}toJson(e){const t={};for(const r in this.format)t[r]=this.format[r].toJson(e[r]);return t}}class s{
constructor(e,t){this.keyFormat=e,this.valueFormat=t}fromJson(e){
return new Map(e.map((({key:e,value:t})=>[this.keyFormat.fromJson(e),this.valueFormat.fromJson(t)])))}toJson(e){
return[...e.entries()].map((([e,t])=>({key:this.keyFormat.toJson(e),value:this.valueFormat.toJson(t)})))}}class a{
constructor(e){this.format=e}fromJson(e){return new Set(e.map((e=>this.format.fromJson(e))))}toJson(e){
return[...e].map((e=>this.format.toJson(e)))}}class i{fromJson(e){return e}toJson(e){return e}}})),m=u((function(e,t){
Object.defineProperty(t,"__esModule",{value:!0}),t.PackageTree=t.Package=void 0;class r{}t.Package=r,function(e){
e.json=function(){return l.JsonFormat.object({id:l.JsonFormat.string(),
deps:l.JsonFormat.map(l.JsonFormat.string(),l.JsonFormat.string()),path:l.JsonFormat.string()})}
}(r=t.Package||(t.Package={})),(t.PackageTree||(t.PackageTree={})).json=function(){
return l.JsonFormat.map(l.JsonFormat.string(),r.json())}}));const p=process.env.NODE_PACKAGE_MANIFEST
;if(!p)throw new Error("NODE_PACKAGE_MANIFEST is not set")
;const d=l.JsonFormat.parse(m.PackageTree.json(),a.readFileSync(p,"utf8"));!function(e,t){
t._resolveFilename=function(e,t){return function(r,n,o,s){
if(i.default.builtinModules.includes(r)||!n||"internal"===n.path||"."==r||".."==r||r.startsWith("./")||r.startsWith("../")||r.startsWith("/"))return t.apply(this,arguments)
;const a=r=e.resolve(n.path,r),[u,c]=a.package.split("/node_modules/",2);r=c,a.inner&&(r=`${r}/${a.inner}`)
;const f=new i.default(`${u}/_`,n);return f.filename=n.filename,f.paths=[`${u}/node_modules`],t.call(this,r,f,o,s)}
}(e,t._resolveFilename)}(f.Resolver.create(d,!0),require("module"));