import "zone.js";
import { enableProdMode } from "@angular/core";
import { platformBrowser } from "@angular/platform-browser";
import { ExampleModule } from "./module";

enableProdMode();

platformBrowser()
  .bootstrapModule(ExampleModule)
  .catch((e) => console.error(e));
