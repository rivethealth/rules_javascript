import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { MatButtonToggleModule } from "@angular/material/button-toggle";
import { BrowserModule } from "@angular/platform-browser";
import { ExampleComponent } from "./example.component";
import { ExampleService } from "./service";

@NgModule({
  bootstrap: [ExampleComponent],
  declarations: [ExampleComponent],
  imports: [BrowserModule, CommonModule, MatButtonToggleModule],
  providers: [ExampleService],
})
export class ExampleModule {}
