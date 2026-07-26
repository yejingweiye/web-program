import request from '@/utils/request'
import type { ApiResult, PostInfo, PostComment, PageResult } from '@/types'

export function createPost(data: { communityId: number; title: string; content?: string; imgList?: string; city?: string; address?: string; startTime?: string; budget?: number; peopleNum?: number; tags?: string; scope?: number }) {
  return request.post<ApiResult<PostInfo>>('/post/create', data)
}

export function getPostPage(params: { communityId?: number; page?: number; size?: number }) {
  return request.get<ApiResult<PageResult<PostInfo>>>('/post/page', { params })
}

export function getPublicPosts(page = 1, size = 10) {
  return request.get<ApiResult<PageResult<PostInfo>>>('/post/public/page', { params: { page, size } })
}

export function getPostDetail(id: number) {
  return request.get<ApiResult<PostInfo>>(`/post/detail/${id}`)
}

export function getMyPosts(page = 1, size = 10) {
  return request.get<ApiResult<PageResult<PostInfo>>>('/post/my', { params: { page, size } })
}

export function likePost(postId: number) {
  return request.post<ApiResult<void>>(`/post/like/${postId}`)
}

export function unlikePost(postId: number) {
  return request.post<ApiResult<void>>(`/post/unlike/${postId}`)
}

export function addComment(postId: number, content: string, parentId?: number) {
  return request.post<ApiResult<PostComment>>(`/post/comment/${postId}`, null, { params: { content, parentId } })
}

export function getComments(postId: number, page = 1, size = 10) {
  return request.get<ApiResult<PageResult<PostComment>>>(`/post/comments/${postId}`, { params: { page, size } })
}

export function deletePost(postId: number) {
  return request.delete<ApiResult<void>>(`/post/delete/${postId}`)
}

export function topPost(data: { postId: number; topType: number }) {
  return request.post<ApiResult<PostInfo>>('/post/top', data)
}
