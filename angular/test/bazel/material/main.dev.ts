import "reflect-metadata";
import "@angular/compiler";
import "zone.js";
import { platformBrowserDynamic } from "@angular/platform-browser-dynamic";
import { ExampleModule } from "./module";

platformBrowserDynamic()
  .bootstrapModule(ExampleModule)
  .catch((e) => console.error(e));
