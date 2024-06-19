package koula.diallo.book.manage;

import io.swagger.v3.oas.annotations.tags.Tag;
import koula.diallo.book.common.PageResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("manage")
@RequiredArgsConstructor
@Tag(name = "User")
public class ManagerController {
    private final ManagerService service;

    @GetMapping
    public ResponseEntity<PageResponse<UserResponse>> findAllUsers(
            @RequestParam(name = "page", defaultValue = "0", required = false) int page,
            @RequestParam(name = "size", defaultValue = "0", required = false) int size,
            Authentication connectedUser
    ) {
        return ResponseEntity.ok(service.findAllUsers(page, size, connectedUser));
    }
}
