import { Injectable } from "@angular/core";
import { timer } from "rxjs";

@Injectable()
export class ExampleService {
  readonly value$ = timer(0, 1000);
}
