import { enableProdMode } from "@angular/core";
import { platformBrowser } from "@angular/platform-browser";
import "zone.js";
import { ExampleModule } from "./module";

enableProdMode();

platformBrowser()
  .bootstrapModule(ExampleModule)
  .catch((error) => console.error(error));
