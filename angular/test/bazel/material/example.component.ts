import { Component } from "@angular/core";
import { ExampleService } from "./service";

@Component({ selector: "example", templateUrl: "./example.component.html" })
export class ExampleComponent {
  constructor(private readonly service: ExampleService) {}

  readonly value$ = this.service.value$;
}
