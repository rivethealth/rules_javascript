"use strict";var e=require("path"),t=require("fs"),r=require("module");function o(e){
return e&&"object"==typeof e&&"default"in e?e:{default:e}}function n(e){if(e&&e.__esModule)return e
;var t=Object.create(null);return e&&Object.keys(e).forEach((function(r){if("default"!==r){
var o=Object.getOwnPropertyDescriptor(e,r);Object.defineProperty(t,r,o.get?o:{enumerable:!0,get:function(){return e[r]}
})}})),t.default=e,Object.freeze(t)}var s=o(e),a=n(t),i=o(r);function c(e,t,r){return e(r={path:t,exports:{},
require:function(e,t){return function(){
throw new Error("Dynamic requires are not currently supported by @rollup/plugin-commonjs")}(null==t&&r.path)}
},r.exports),r.exports}var u=c((function(e,t){Object.defineProperty(t,"__esModule",{value:!0}),t.Trie=void 0
;t.Trie=class{constructor(){this.data={children:new Map}}getClosest(e){let t,r=this.data;for(t=0;t<e.length&&r;t++){
const o=e[t],n=r.children.get(o);if(!n)break;r=n}return{rest:e.slice(t),value:r.value}}put(e,t){let r=this.data
;for(const t of e){let e=r.children.get(t);e||(e={children:new Map},r.children.set(t,e)),r=e}r.value=t}}
})),l=c((function(e,t){function r(e){return e?e.split("/"):[]}function o(e){
return(e=s.default.resolve(e)).split("/").slice(1)}Object.defineProperty(t,"__esModule",{value:!0}),t.Resolver=void 0
;class n{constructor(e){this.packages=e}resolve(e,t){
if(t.startsWith(".")||t.startsWith("/"))throw new Error(`Specifier "${t}" is not for a package`)
;const{value:n}=this.packages.getClosest(o(e));if(!n)throw new Error(`File "${e}" is not part of any known package`)
;const{rest:s,value:a}=n.deps.getClosest(r(t))
;if(!a)throw new Error(`Package "${n.id}" does not have any dependency for "${t}"`);return{package:a,inner:s.join("/")}}
static create(e,t){
const a=e=>s.default.resolve(t?`${process.env.RUNFILES_DIR}/${process.env.BAZEL_WORKSPACE}/${e}`:e),i=new u.Trie
;for(const[t,n]of e.entries()){const s=o(a(n.path)),c=new u.Trie;for(const[o,s]of n.deps.entries()){const n=e.get(s)
;if(!n)throw new Error(`Package "${s}" referenced by "${t}" does not exist`);const i=a(n.path);c.put(r(o),i)}i.put(s,{
id:t,deps:c})}return new n(i)}}t.Resolver=n})),f=c((function(e,t){var r;Object.defineProperty(t,"__esModule",{value:!0
}),t.JsonFormat=void 0,(r=t.JsonFormat||(t.JsonFormat={})).parse=function(e,t){return e.fromJson(JSON.parse(t))},
r.stringify=function(e,t){return JSON.stringify(e.toJson(t))},function(e){e.array=function(e){return new o(e)},
e.map=function(e,t){return new s(e,t)},e.object=function(e){return new n(e)},e.defer=function(e){return{
fromJson:t=>e().fromJson(t),toJson:t=>e().toJson(t)}},e.set=function(e){return new a(e)},e.string=function(){
return new i}}(t.JsonFormat||(t.JsonFormat={}));class o{constructor(e){this.elementFormat=e}fromJson(e){
return e.map((e=>this.elementFormat.fromJson(e)))}toJson(e){return e.map((e=>this.elementFormat.toJson(e)))}}class n{
constructor(e){this.format=e}fromJson(e){const t={};for(const r in this.format)t[r]=this.format[r].fromJson(e[r])
;return t}toJson(e){const t={};for(const r in this.format)t[r]=this.format[r].toJson(e[r]);return t}}class s{
constructor(e,t){this.keyFormat=e,this.valueFormat=t}fromJson(e){
return new Map(e.map((({key:e,value:t})=>[this.keyFormat.fromJson(e),this.valueFormat.fromJson(t)])))}toJson(e){
return[...e.entries()].map((([e,t])=>({key:this.keyFormat.toJson(e),value:this.valueFormat.toJson(t)})))}}class a{
constructor(e){this.format=e}fromJson(e){return new Set(e.map((e=>this.format.fromJson(e))))}toJson(e){
return[...e].map((e=>this.format.toJson(e)))}}class i{fromJson(e){return e}toJson(e){return e}}})),p=c((function(e,t){
Object.defineProperty(t,"__esModule",{value:!0}),t.PackageTree=t.Package=void 0;class r{}t.Package=r,function(e){
e.json=function(){return f.JsonFormat.object({id:f.JsonFormat.string(),
deps:f.JsonFormat.map(f.JsonFormat.string(),f.JsonFormat.string()),path:f.JsonFormat.string()})}
}(r=t.Package||(t.Package={})),(t.PackageTree||(t.PackageTree={})).json=function(){
return f.JsonFormat.map(f.JsonFormat.string(),r.json())}}));const m=process.env.NODE_PACKAGE_MANIFEST
;if(!m)throw new Error("NODE_PACKAGE_MANIFEST is not set")
;const h=f.JsonFormat.parse(p.PackageTree.json(),a.readFileSync(m,"utf8"));!function(e,t){
t._resolveFilename=function(e,t){return function(r,o,n,s){
if(i.default.builtinModules.includes(r)||!o||"internal"===o.path||"."==r||".."==r||r.startsWith("./")||r.startsWith("../")||r.startsWith("/"))return t.apply(this,arguments)
;const a=r=e.resolve(o.path,r);let c=a.package.split("/").slice(-1)[0];a.inner&&(c=`${c}/${a.inner}`)
;const u=i.default._resolveLookupPaths;i.default._resolveLookupPaths=()=>[a.package.split("/").slice(0,-1).join("/")]
;try{return t.call(this,c,o,n,s)}finally{i.default._resolveLookupPaths=u}}}(e,t._resolveFilename)
}(l.Resolver.create(h,!0),require("module"));