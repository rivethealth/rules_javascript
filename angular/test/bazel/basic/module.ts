import { CommonModule } from "@angular/common";
import { NgModule } from "@angular/core";
import { ExampleComponent } from "./example.component";
import { ExampleService } from "./service";

@NgModule({
  bootstrap: [ExampleComponent],
  declarations: [ExampleComponent],
  imports: [CommonModule],
  providers: [ExampleService],
})
export class ExampleModule {}
