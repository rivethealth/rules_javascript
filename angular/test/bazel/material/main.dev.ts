import "@angular/compiler";
import { platformBrowserDynamic } from "@angular/platform-browser-dynamic";
import "reflect-metadata";
import "zone.js";
import { ExampleModule } from "./module";

platformBrowserDynamic()
  .bootstrapModule(ExampleModule)
  .catch((error) => console.error(error));
