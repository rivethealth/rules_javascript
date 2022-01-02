import { NgModule } from "@angular/core";
import { MatButtonToggleModule } from "@angular/material/button-toggle";
import { ExampleComponent } from "./example.component";
import { BrowserModule } from "@angular/platform-browser";
import { ExampleService } from "./service";
import { CommonModule } from "@angular/common";

@NgModule({
  bootstrap: [ExampleComponent],
  declarations: [ExampleComponent],
  imports: [BrowserModule, CommonModule, MatButtonToggleModule],
  providers: [ExampleService],
})
export class ExampleModule {}
