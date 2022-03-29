import { Component } from "@angular/core";
import { ExampleService } from "./service";

@Component({
  selector: "example",
  templateUrl: "./example.component.html",
  styleUrls: ["./example.component.scss"],
})
export class ExampleComponent {
  constructor(private readonly service: ExampleService) {}

  readonly value$ = this.service.value$;
}
