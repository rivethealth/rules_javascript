"use strict";var t=require("path"),e=require("fs"),r=require("module");function n(t){
return t&&"object"==typeof t&&"default"in t?t:{default:t}}function o(t){if(t&&t.__esModule)return t
;var e=Object.create(null);return t&&Object.keys(t).forEach((function(r){if("default"!==r){
var n=Object.getOwnPropertyDescriptor(t,r);Object.defineProperty(e,r,n.get?n:{enumerable:!0,get:function(){return t[r]}
})}})),e.default=t,Object.freeze(e)}var s,a,i=o(t),c=o(e),u=n(r);class f{constructor(){this.data={children:new Map}}
getClosest(t){let e,r=this.data;for(e=0;e<t.length&&r;e++){const n=t[e],o=r.children.get(n);if(!o)break;r=o}return{
rest:t.slice(e),value:r.value}}put(t,e){let r=this.data;for(const e of t){let t=r.children.get(e);t||(t={
children:new Map},r.children.set(e,t)),r=t}r.value=e}}function l(t){return t?t.split("/"):[]}function p(t){
return(t=i.resolve(t)).split("/").slice(1)}class h{constructor(t){this.packages=t}resolve(t,e){
if(e.startsWith(".")||e.startsWith("/"))throw new Error(`Specifier "${e}" is not for a package`)
;const{value:r}=this.packages.getClosest(p(t));if(!r)throw new Error(`File "${t}" is not part of any known package`)
;const{rest:n,value:o}=r.deps.getClosest(l(e))
;if(!o)throw new Error(`Package "${r.id}" does not have any dependency for "${e}"`);return{package:o,inner:n.join("/")}}
static create(t,e){const r=t=>i.resolve(e?`${process.env.RUNFILES_DIR}/${process.env.BAZEL_WORKSPACE}/${t}`:t),n=new f
;for(const[e,o]of t.entries()){const s=p(r(o.path)),a=new f;for(const[n,s]of o.deps.entries()){const o=t.get(s)
;if(!o)throw new Error(`Package "${o}" referenced by "${e}" does not exist`);const i=r(o.path);a.put(l(n),i)}n.put(s,{
id:e,deps:a})}return new h(n)}}!function(t){t.parse=function(t,e){return t.fromJson(JSON.parse(e))},
t.stringify=function(t,e){return JSON.stringify(t.toJson(e))}}(s||(s={})),function(t){t.array=function(t){
return new m(t)},t.map=function(t,e){return new J(t,e)},t.object=function(t){return new d(t)},t.defer=function(t){
return{fromJson:e=>t().fromJson(e),toJson:e=>t().toJson(e)}},t.set=function(t){return new g(t)},t.string=function(){
return new v}}(s||(s={}));class m{constructor(t){this.elementFormat=t}fromJson(t){
return t.map((t=>this.elementFormat.fromJson(t)))}toJson(t){return t.map((t=>this.elementFormat.toJson(t)))}}class d{
constructor(t){this.format=t}fromJson(t){const e={};for(const r in this.format)e[r]=this.format[r].fromJson(t[r])
;return e}toJson(t){const e={};for(const r in this.format)e[r]=this.format[r].toJson(t[r]);return e}}class J{
constructor(t,e){this.keyFormat=t,this.valueFormat=e}fromJson(t){
return new Map(t.map((({key:t,value:e})=>[this.keyFormat.fromJson(t),this.valueFormat.fromJson(e)])))}toJson(t){
return[...t.entries()].map((([t,e])=>({key:this.keyFormat.toJson(t),value:this.valueFormat.toJson(e)})))}}class g{
constructor(t){this.format=t}fromJson(t){return new Set(t.map((t=>this.format.fromJson(t))))}toJson(t){
return[...t].map((t=>this.format.toJson(t)))}}class v{fromJson(t){return t}toJson(t){return t}}class w{}!function(t){
t.json=function(){return s.object({id:s.string(),deps:s.map(s.string(),s.string()),path:s.string()})}}(w||(w={})),
function(t){t.json=function(){return s.map(s.string(),w.json())}}(a||(a={}));const k=process.env.NODE_PACKAGE_MANIFEST
;if(!k)throw new Error("NODE_PACKAGE_MANIFEST is not set");const y=s.parse(a.json(),c.readFileSync(k,"utf8"))
;!function(t,e){e._resolveFilename=function(t,e){return function(r,n,o,s){
if(u.default.builtinModules.includes(r)||!n||"internal"===n.path||"."==r||r.startsWith("./")||r.startsWith("../")||r.startsWith("/"))return e.apply(this,arguments)
;const a=r=t.resolve(n.path,r);let i=a.package.split("/").slice(-1)[0];a.inner&&(i=`${i}/${a.inner}`)
;const c=u.default._resolveLookupPaths;u.default._resolveLookupPaths=()=>[a.package.split("/").slice(0,-1).join("/")]
;try{return e.call(this,i,n,o,s)}finally{u.default._resolveLookupPaths=c}}}(t,e._resolveFilename)
}(h.create(y,!0),require("module"));