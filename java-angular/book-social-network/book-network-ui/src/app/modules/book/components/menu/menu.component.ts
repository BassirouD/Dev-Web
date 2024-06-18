import {Component, OnInit} from '@angular/core';
import {TokenService} from "../../../../services/token/token.service";

@Component({
    selector: 'app-menu',
    templateUrl: './menu.component.html',
    styleUrl: './menu.component.scss'
})
export class MenuComponent implements OnInit {
    username!: string

    constructor(private tokenSrv: TokenService) {
    }

    ngOnInit(): void {
        this.username = this.tokenSrv.fullName as string
        const linkColor = document.querySelectorAll('.nav-link');
        linkColor.forEach(link => {
            if (window.location.href.endsWith(link.getAttribute('href') || '')) {
                link.classList.add('active');
            }
            link.addEventListener('click', () => {
                linkColor.forEach(l => l.classList.remove('active'))
                link.classList.add('active');
            })
        })
    }

    logout() {
        localStorage.clear()
        window.location.reload()
    }
}
