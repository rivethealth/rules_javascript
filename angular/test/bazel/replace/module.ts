import { NgModule } from "@angular/core";
import { ExampleComponent } from "./example.component";
import { ExampleService } from "./service";
import { CommonModule } from "@angular/common";

@NgModule({
  bootstrap: [ExampleComponent],
  declarations: [ExampleComponent],
  imports: [CommonModule],
  providers: [ExampleService],
})
export class ExampleModule {}
